//
//  Tooltip.swift
//  Logic
//
//  Created by Devin Abbott on 9/6/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import Foundation

public class TooltipWindow: NSWindow {
    public static var shared = TooltipWindow()

    public static var contentInsets: NSEdgeInsets = .init(top: 6, left: 8, bottom: 6, right: 8)

    public convenience init() {
        self.init(
            contentRect: NSRect(origin: .zero, size: .zero),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false)

        level = .floating

        let window = self
        window.backgroundColor = NSColor.clear
        window.isOpaque = false

        contentView = container
    }

    private lazy var container: NSBox = {
        let container = NSBox()

        container.boxType = .custom
        container.borderType = .lineBorder
        container.contentViewMargins = .zero
        container.cornerRadius = 4
        container.fillColor = Colors.background
        container.borderColor = Colors.divider

        container.translatesAutoresizingMaskIntoConstraints = false

        return container
    }()

    public var markdownText: String = "" {
        didSet {
            tooltipView = LightMark.makeContentView(
                LightMark.parse(markdownText),
                padding: TooltipWindow.contentInsets,
                renderingOptions: .init(formattingOptions: .visual)
            )
        }
    }

    public var tooltipView: NSView = NSView() {
        didSet {
            if oldValue == tooltipView { return }

            oldValue.removeFromSuperview()

            container.addSubview(tooltipView)

            tooltipView.translatesAutoresizingMaskIntoConstraints = false
            tooltipView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
            tooltipView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            tooltipView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
            tooltipView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true

            setContentSize(tooltipView.fittingSize)
        }
    }

    override public var ignoresMouseEvents: Bool {
        get { return true }
        set {}
    }
}

public class TooltipManager {

    public enum PreferredEdge {
        case top, bottom
    }

    private var window: TooltipWindow

    public init(window: TooltipWindow) {
        self.window = window
    }

    public func hideTooltip() -> Void {
        if let item = self.currentWorkItem, !item.isCancelled {
            item.cancel()
        }

        window.orderOut(nil)
    }

    public func showTooltip(string: String, point: NSPoint, preferredEdge: PreferredEdge = .bottom, delay: DispatchTimeInterval) -> Void {
        if let item = self.currentWorkItem, !item.isCancelled {
            item.cancel()
        }

        let currentWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            // Set text first, since this updates the window frame
            self.window.markdownText = string

            let origin = preferredEdge == .bottom
                ? NSPoint(
                    x: point.x - self.window.frame.width / 2,
                    y: point.y - self.window.frame.height)
                : NSPoint(
                    x: point.x - self.window.frame.width / 2,
                    y: point.y)

            self.window.setFrameOrigin(origin)
            self.window.orderFront(nil)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: currentWorkItem)

        self.currentWorkItem = currentWorkItem
    }

    private var currentWorkItem: DispatchWorkItem?

    public static var shared = TooltipManager(window: TooltipWindow.shared)
}
