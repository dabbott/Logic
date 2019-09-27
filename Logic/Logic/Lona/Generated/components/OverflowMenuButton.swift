// Generated by Lona Compiler 0.6.0

import AppKit
import Foundation

// MARK: - OverflowMenuButton

public class OverflowMenuButton: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()

    addTrackingArea(trackingArea)
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

  public var onPressButton: (() -> Void)? {
    get { return parameters.onPressButton }
    set { parameters.onPressButton = newValue }
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

  private var line1View = NSBox()
  private var line2View = NSBox()
  private var line3View = NSBox()

  private var hovered = false
  private var pressed = false
  private var onPress: (() -> Void)?

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    line1View.boxType = .custom
    line1View.borderType = .noBorder
    line1View.contentViewMargins = .zero
    line2View.boxType = .custom
    line2View.borderType = .noBorder
    line2View.contentViewMargins = .zero
    line3View.boxType = .custom
    line3View.borderType = .noBorder
    line3View.contentViewMargins = .zero

    addSubview(line1View)
    addSubview(line2View)
    addSubview(line3View)

    cornerRadius = 4
    line1View.fillColor = Colors.textMuted
    line1View.cornerRadius = 2
    line2View.fillColor = Colors.textMuted
    line2View.cornerRadius = 2
    line3View.fillColor = Colors.textMuted
    line3View.cornerRadius = 2
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    line1View.translatesAutoresizingMaskIntoConstraints = false
    line2View.translatesAutoresizingMaskIntoConstraints = false
    line3View.translatesAutoresizingMaskIntoConstraints = false

    let heightAnchorConstraint = heightAnchor.constraint(equalToConstant: 13)
    let widthAnchorConstraint = widthAnchor.constraint(equalToConstant: 23)
    let line1ViewLeadingAnchorConstraint = line1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
    let line1ViewTopAnchorConstraint = line1View.topAnchor.constraint(equalTo: topAnchor, constant: 5)
    let line2ViewLeadingAnchorConstraint = line2View
      .leadingAnchor
      .constraint(equalTo: line1View.trailingAnchor, constant: 2)
    let line2ViewTopAnchorConstraint = line2View.topAnchor.constraint(equalTo: topAnchor, constant: 5)
    let line3ViewLeadingAnchorConstraint = line3View
      .leadingAnchor
      .constraint(equalTo: line2View.trailingAnchor, constant: 2)
    let line3ViewTopAnchorConstraint = line3View.topAnchor.constraint(equalTo: topAnchor, constant: 5)
    let line1ViewHeightAnchorConstraint = line1View.heightAnchor.constraint(equalToConstant: 3)
    let line1ViewWidthAnchorConstraint = line1View.widthAnchor.constraint(equalToConstant: 3)
    let line2ViewHeightAnchorConstraint = line2View.heightAnchor.constraint(equalToConstant: 3)
    let line2ViewWidthAnchorConstraint = line2View.widthAnchor.constraint(equalToConstant: 3)
    let line3ViewHeightAnchorConstraint = line3View.heightAnchor.constraint(equalToConstant: 3)
    let line3ViewWidthAnchorConstraint = line3View.widthAnchor.constraint(equalToConstant: 3)

    NSLayoutConstraint.activate([
      heightAnchorConstraint,
      widthAnchorConstraint,
      line1ViewLeadingAnchorConstraint,
      line1ViewTopAnchorConstraint,
      line2ViewLeadingAnchorConstraint,
      line2ViewTopAnchorConstraint,
      line3ViewLeadingAnchorConstraint,
      line3ViewTopAnchorConstraint,
      line1ViewHeightAnchorConstraint,
      line1ViewWidthAnchorConstraint,
      line2ViewHeightAnchorConstraint,
      line2ViewWidthAnchorConstraint,
      line3ViewHeightAnchorConstraint,
      line3ViewWidthAnchorConstraint
    ])
  }

  private func update() {
    fillColor = Colors.divider
    onPress = handleOnPressButton
    if hovered {
      fillColor = Colors.dividerBackground
    }
  }

  private func handleOnPressButton() {
    onPressButton?()
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

extension OverflowMenuButton {
  public struct Parameters: Equatable {
    public var onPressButton: (() -> Void)?

    public init(onPressButton: (() -> Void)? = nil) {
      self.onPressButton = onPressButton
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return true
    }
  }
}

// MARK: - Model

extension OverflowMenuButton {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "OverflowMenuButton"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(onPressButton: (() -> Void)? = nil) {
      self.init(Parameters(onPressButton: onPressButton))
    }
  }
}
