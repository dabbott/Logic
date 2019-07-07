import AppKit
import Foundation

// MARK: - FilterLabel

public class FilterLabel: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()

    addTrackingArea(trackingArea)
  }

  public convenience init(isActive: Bool, titleText: String) {
    self.init(Parameters(isActive: isActive, titleText: titleText))
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

  public var isActive: Bool {
    get { return parameters.isActive }
    set {
      if parameters.isActive != newValue {
        parameters.isActive = newValue
      }
    }
  }

  public var onClick: (() -> Void)? {
    get { return parameters.onClick }
    set { parameters.onClick = newValue }
  }

  public var titleText: String {
    get { return parameters.titleText }
    set {
      if parameters.titleText != newValue {
        parameters.titleText = newValue
      }
    }
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

  private var textView = LNATextField(labelWithString: "")

  private var textViewTextStyle = TextStyles.sectionHeaderInverse

  private var hovered = false
  private var pressed = false
  private var onPress: (() -> Void)?

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    textView.lineBreakMode = .byWordWrapping

    addSubview(textView)

    cornerRadius = 4
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false

    let textViewHeightAnchorParentConstraint = textView
      .heightAnchor
      .constraint(lessThanOrEqualTo: heightAnchor, constant: -4)
    let textViewLeadingAnchorConstraint = textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)
    let textViewTrailingAnchorConstraint = textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
    let textViewTopAnchorConstraint = textView.topAnchor.constraint(equalTo: topAnchor, constant: 2)
    let textViewCenterYAnchorConstraint = textView.centerYAnchor.constraint(equalTo: centerYAnchor)
    let textViewBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)

    textViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow

    NSLayoutConstraint.activate([
      textViewHeightAnchorParentConstraint,
      textViewLeadingAnchorConstraint,
      textViewTrailingAnchorConstraint,
      textViewTopAnchorConstraint,
      textViewCenterYAnchorConstraint,
      textViewBottomAnchorConstraint
    ])
  }

  private func update() {
    fillColor = #colorLiteral(red: 0.78431372549, green: 0.78431372549, blue: 0.78431372549, alpha: 1)
    textViewTextStyle = TextStyles.sectionHeaderInverse
    textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
    onPress = handleOnClick
    if isActive == false {
      fillColor = Colors.transparent
      textViewTextStyle = TextStyles.sectionHeader
      textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
    }
    textView.attributedStringValue = textViewTextStyle.apply(to: titleText)
  }

  private func handleOnClick() {
    onClick?()
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

extension FilterLabel {
  public struct Parameters: Equatable {
    public var isActive: Bool
    public var titleText: String
    public var onClick: (() -> Void)?

    public init(isActive: Bool, titleText: String, onClick: (() -> Void)? = nil) {
      self.isActive = isActive
      self.titleText = titleText
      self.onClick = onClick
    }

    public init() {
      self.init(isActive: false, titleText: "")
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.isActive == rhs.isActive && lhs.titleText == rhs.titleText
    }
  }
}

// MARK: - Model

extension FilterLabel {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "FilterLabel"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(isActive: Bool, titleText: String, onClick: (() -> Void)? = nil) {
      self.init(Parameters(isActive: isActive, titleText: titleText, onClick: onClick))
    }

    public init() {
      self.init(isActive: false, titleText: "")
    }
  }
}