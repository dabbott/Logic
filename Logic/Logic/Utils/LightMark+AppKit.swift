//
//  LightMark+AppKit.swift
//  LogicDesigner
//
//  Created by Devin Abbott on 3/3/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import AppKit

// https://stackoverflow.com/a/48583402
extension Sequence where Iterator.Element: NSAttributedString {
    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(separator: NSAttributedString = NSAttributedString(string: "")) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(separator: String = "") -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

extension LightMark.HeadingLevel {
    var weight: NSFont.Weight {
        switch self {
        case .level1:
            return .regular
        case .level2:
            return .medium
        case .level3, .level4, .level5, .level6:
            fatalError("Unhandled heading level")
        }
    }

    var size: CGFloat {
        switch self {
        case .level1:
            return 18
        case .level2:
            return 12
        case .level3, .level4, .level5, .level6:
            fatalError("Unhandled heading level")
        }
    }
}

extension LightMark.TextStyle {
    var weight: NSFont.Weight? {
        switch self {
        case .strong:
            return .bold
        case .emphasis, .strikethrough:
            return nil
        }
    }
}

extension LightMark.QuoteKind {
    public var backgroundColor: NSColor {
        switch self {
        case .none:
            return Colors.dividerBackground
        case .info:
            return NSColor.systemBlue.withAlphaComponent(0.5)
        case .warning:
            return NSColor.systemYellow.withAlphaComponent(0.5)
        case .error:
            return NSColor.systemRed.withAlphaComponent(0.5)
        }
    }

    public var icon: NSImage? {
        switch self {
        case .none:
            return nil
        case .info:
            return LightMark.QuoteKind.iconInfo
        case .warning:
            return LightMark.QuoteKind.iconWarning
        case .error:
            return LightMark.QuoteKind.iconError
        }
    }

    public static var iconInfo = BundleLocator.getBundle().image(forResource: NSImage.Name("icon-info"))!
    public static var iconWarning = BundleLocator.getBundle().image(forResource: NSImage.Name("icon-warning"))!
    public static var iconError = BundleLocator.getBundle().image(forResource: NSImage.Name("icon-error"))!

    public static var iconMargin = NSEdgeInsets(top: 3, left: 4, bottom: 0, right: 4)
    public static var paragraphMargin = NSEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
}

typealias LogicTextStyle = TextStyle

extension LightMark {
    static func makeTextStyle(headingLevel: HeadingLevel? = nil, textStyle: TextStyle? = nil, isCode: Bool = false) -> LogicTextStyle {
        let weight: NSFont.Weight = textStyle?.weight ?? headingLevel?.weight ?? .regular
        let size: CGFloat = headingLevel?.size ?? 12

        return LogicTextStyle(weight: weight, size: size, lineHeight: 18, color: isCode ? Colors.editableText : nil)
    }
}

extension LightMark.InlineElement {
    func attributedString() -> NSAttributedString {
        switch self {
        case .text(content: let content):
            return LightMark.makeTextStyle().apply(to: content)
        case .styledText(style: let style, content: let content):
            return LightMark.makeTextStyle(textStyle: style)
                .apply(to: content.map { $0.attributedString() }.joined(separator: ""))
        case .code(content: let content):
            return LightMark.makeTextStyle(isCode: true).apply(to: content)
        default:
            return NSAttributedString()
        }
    }
}

extension LightMark.BlockElement {
    var view: NSView {
        switch self {
        case .heading(let headingLevel, let content):
            let attributedString = LightMark.makeTextStyle(headingLevel: headingLevel)
                .apply(to: content.map { $0.attributedString() }.joined(separator: ""))
            return NSTextField(labelWithAttributedString: attributedString)
        case .quote(kind: let kind, content: let blocks):
            let container = NSBox()
            container.boxType = .custom
            container.borderType = .noBorder
            container.fillColor = kind.backgroundColor
            container.contentViewMargins = .zero
            container.cornerRadius = 4

            let icon = kind.icon ?? NSImage()
            let iconView = NSImageView(image: icon)

            let blockView = LightMark.makeContentView(blocks, padding: 0)

            container.addSubview(blockView)
            container.addSubview(iconView)

            container.translatesAutoresizingMaskIntoConstraints = false
            iconView.translatesAutoresizingMaskIntoConstraints = false
            blockView.translatesAutoresizingMaskIntoConstraints = false

            let iconMargin = LightMark.QuoteKind.iconMargin
            let paragraphMargin = LightMark.QuoteKind.paragraphMargin

            iconView.widthAnchor.constraint(equalToConstant: icon.size.width).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: icon.size.height).isActive = true
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: iconMargin.top).isActive = true
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: iconMargin.left).isActive = true

            blockView.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: iconMargin.right + paragraphMargin.left).isActive = true

            blockView.topAnchor.constraint(equalTo: container.topAnchor, constant: paragraphMargin.top).isActive = true
            blockView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: paragraphMargin.bottom).isActive = true
            blockView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -paragraphMargin.right).isActive = true

            return container
        case .paragraph(let elements):
            let string = elements.map { $0.attributedString() }.joined(separator: "")

            return NSTextField(labelWithAttributedString: string)
        case .block(language: "logic", content: let content):
            guard let data = content.data(using: .utf8) else { fatalError("Invalid utf8 data in markdown code block") }

            guard let node = LGCSyntaxNode(data: data) else {
                Swift.print("Failed to create documentation code block from", content)
                return NSView()
            }

            return node.makeCodeView(using: .normal)
        case .lineBreak:
            return NSView()
        default:
            fatalError("Unhandled type")
        }
    }

    var marginTop: CGFloat {
        switch self {
        case .heading(let headingSize, _):
            switch headingSize {
            case .level1:
                return 24
            case .level2:
                return 18
            case .level3, .level4, .level5, .level6:
                fatalError("Unhandled heading level")
            }
        case .paragraph, .block, .quote:
            return 8
//        case .custom:
//            return 12
//        case .alert:
//            return 8
        case .lineBreak:
            return 18
        default:
            fatalError("Unhandled type")
        }
    }
}

private class FlippedView: NSView {
    override var isFlipped: Bool {
        return true
    }
}

extension LightMark {
    public static func makeContentView(_ blocks: [LightMark.BlockElement], padding: CGFloat) -> NSView {
        let blockViews = blocks.map { $0.view }

        let contentView = FlippedView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        if blockViews.count > 0 {
            for (offset, view) in blockViews.enumerated() {
                contentView.addSubview(view)

                view.translatesAutoresizingMaskIntoConstraints = false
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true

                if offset == 0 {
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
                } else {
                    let margin = max(blocks[offset].marginTop, 8)
                    view.topAnchor.constraint(equalTo: blockViews[offset - 1].bottomAnchor, constant: margin).isActive = true
                }

                if offset == blockViews.count - 1 {
                    view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
                }
            }
        }

        return contentView
    }

    public static func makeScrollView(_ blocks: [LightMark.BlockElement]) -> NSScrollView {
        let contentView = self.makeContentView(blocks, padding: 24)

        let scrollView = NSScrollView()

        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.documentView = contentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.contentView.trailingAnchor).isActive = true

        return scrollView
    }

    public static func makeScrollView(markdown: String) -> NSScrollView {
        return LightMark.makeScrollView(LightMark.parse(markdown))
    }
}
