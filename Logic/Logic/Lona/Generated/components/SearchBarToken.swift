// Generated by Lona Compiler 0.9.1

import AppKit
import Foundation

// MARK: - SearchBarToken

public class SearchBarToken: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()

    addTrackingArea(trackingArea)
  }

  public convenience init(titleText: String) {
    self.init(Parameters(titleText: titleText))
  }

  public convenience init() {
    self.init(Parameters())
  }

  public required init?(coder aDecoder: NSCoder) {
    self.parameters = Parameters()

    super.init(coder: aDecoder)

    setUpViews()
    setUpConstraints()

    update()

    addTrackingArea(trackingArea)
  }

  deinit {
    removeTrackingArea(trackingArea)
  }

  // MARK: Public

  public var titleText: String {
    get { return parameters.titleText }
    set {
      if parameters.titleText != newValue {
        parameters.titleText = newValue
      }
    }
  }

  public var onPressToken: (() -> Void)? {
    get { return parameters.onPressToken }
    set { parameters.onPressToken = newValue }
  }

  public var parameters: Parameters {
    didSet {
      if parameters != oldValue {
        update()
      }
    }
  }

  // MARK: Private

  private lazy var trackingArea = NSTrackingArea(
    rect: self.frame,
    options: [.mouseEnteredAndExited, .activeAlways, .mouseMoved, .inVisibleRect],
    owner: self)

  private var titleView = LNATextField(labelWithString: "")

  private var titleViewTextStyle = TextStyles.rowInverse

  private var hovered = false
  private var pressed = false
  private var onPress: (() -> Void)?

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    titleView.lineBreakMode = .byWordWrapping

    addSubview(titleView)

    fillColor = Colors.divider
    cornerRadius = 2
    titleViewTextStyle = TextStyles.rowInverse
    titleView.attributedStringValue = titleViewTextStyle.apply(to: titleView.attributedStringValue)
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    titleView.translatesAutoresizingMaskIntoConstraints = false

    let titleViewHeightAnchorParentConstraint = titleView
      .heightAnchor
      .constraint(lessThanOrEqualTo: heightAnchor, constant: -8)
    let titleViewLeadingAnchorConstraint = titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
    let titleViewTrailingAnchorConstraint = titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    let titleViewTopAnchorConstraint = titleView.topAnchor.constraint(equalTo: topAnchor, constant: 4)
    let titleViewCenterYAnchorConstraint = titleView.centerYAnchor.constraint(equalTo: centerYAnchor)
    let titleViewBottomAnchorConstraint = titleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)

    titleViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow

    NSLayoutConstraint.activate([
      titleViewHeightAnchorParentConstraint,
      titleViewLeadingAnchorConstraint,
      titleViewTrailingAnchorConstraint,
      titleViewTopAnchorConstraint,
      titleViewCenterYAnchorConstraint,
      titleViewBottomAnchorConstraint
    ])
  }

  private func update() {
    alphaValue = 1
    titleView.attributedStringValue = titleViewTextStyle.apply(to: titleText)
    onPress = handleOnPressToken
    if hovered {
      alphaValue = 0.5
    }
  }

  private func handleOnPressToken() {
    onPressToken?()
  }

  private func updateHoverState(with event: NSEvent) {
    let hovered = bounds.contains(convert(event.locationInWindow, from: nil))
    if hovered != self.hovered {
      self.hovered = hovered

      update()
    }
  }

  public override func mouseEntered(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseMoved(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseDragged(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseExited(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseDown(with event: NSEvent) {
    let pressed = bounds.contains(convert(event.locationInWindow, from: nil))
    if pressed != self.pressed {
      self.pressed = pressed

      update()
    }
  }

  public override func mouseUp(with event: NSEvent) {
    let clicked = pressed && bounds.contains(convert(event.locationInWindow, from: nil))

    if pressed {
      pressed = false

      update()
    }

    if clicked {
      onPress?()
    }
  }
}

// MARK: - Parameters

extension SearchBarToken {
  public struct Parameters: Equatable {
    public var titleText: String
    public var onPressToken: (() -> Void)?

    public init(titleText: String, onPressToken: (() -> Void)? = nil) {
      self.titleText = titleText
      self.onPressToken = onPressToken
    }

    public init() {
      self.init(titleText: "")
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.titleText == rhs.titleText
    }
  }
}

// MARK: - Model

extension SearchBarToken {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "SearchBarToken"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(titleText: String, onPressToken: (() -> Void)? = nil) {
      self.init(Parameters(titleText: titleText, onPressToken: onPressToken))
    }

    public init() {
      self.init(titleText: "")
    }
  }
}
