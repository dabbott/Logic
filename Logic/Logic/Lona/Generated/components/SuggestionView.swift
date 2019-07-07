import AppKit
import Foundation

// MARK: - SuggestionView

public class SuggestionView: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()
  }

  public convenience init(
    searchText: String,
    placeholderText: String?,
    selectedIndex: Int?,
    dropdownIndex: Int,
    dropdownValues: [String],
    detailView: CustomDetailView,
    showsDropdown: Bool,
    suggestionFilter: SuggestionFilter)
  {
    self
      .init(
        Parameters(
          searchText: searchText,
          placeholderText: placeholderText,
          selectedIndex: selectedIndex,
          dropdownIndex: dropdownIndex,
          dropdownValues: dropdownValues,
          detailView: detailView,
          showsDropdown: showsDropdown,
          suggestionFilter: suggestionFilter))
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
  }

  // MARK: Public

  public var searchText: String {
    get { return parameters.searchText }
    set {
      if parameters.searchText != newValue {
        parameters.searchText = newValue
      }
    }
  }

  public var placeholderText: String? {
    get { return parameters.placeholderText }
    set {
      if parameters.placeholderText != newValue {
        parameters.placeholderText = newValue
      }
    }
  }

  public var onChangeSearchText: ((String) -> Void)? {
    get { return parameters.onChangeSearchText }
    set { parameters.onChangeSearchText = newValue }
  }

  public var onPressDownKey: (() -> Void)? {
    get { return parameters.onPressDownKey }
    set { parameters.onPressDownKey = newValue }
  }

  public var onPressUpKey: (() -> Void)? {
    get { return parameters.onPressUpKey }
    set { parameters.onPressUpKey = newValue }
  }

  public var selectedIndex: Int? {
    get { return parameters.selectedIndex }
    set {
      if parameters.selectedIndex != newValue {
        parameters.selectedIndex = newValue
      }
    }
  }

  public var onSelectIndex: ((Int?) -> Void)? {
    get { return parameters.onSelectIndex }
    set { parameters.onSelectIndex = newValue }
  }

  public var onActivateIndex: ((Int) -> Void)? {
    get { return parameters.onActivateIndex }
    set { parameters.onActivateIndex = newValue }
  }

  public var onSubmit: (() -> Void)? {
    get { return parameters.onSubmit }
    set { parameters.onSubmit = newValue }
  }

  public var onPressTabKey: (() -> Void)? {
    get { return parameters.onPressTabKey }
    set { parameters.onPressTabKey = newValue }
  }

  public var onPressShiftTabKey: (() -> Void)? {
    get { return parameters.onPressShiftTabKey }
    set { parameters.onPressShiftTabKey = newValue }
  }

  public var onPressEscapeKey: (() -> Void)? {
    get { return parameters.onPressEscapeKey }
    set { parameters.onPressEscapeKey = newValue }
  }

  public var onSelectDropdownIndex: ((Int) -> Void)? {
    get { return parameters.onSelectDropdownIndex }
    set { parameters.onSelectDropdownIndex = newValue }
  }

  public var onHighlightDropdownIndex: ((Int?) -> Void)? {
    get { return parameters.onHighlightDropdownIndex }
    set { parameters.onHighlightDropdownIndex = newValue }
  }

  public var dropdownIndex: Int {
    get { return parameters.dropdownIndex }
    set {
      if parameters.dropdownIndex != newValue {
        parameters.dropdownIndex = newValue
      }
    }
  }

  public var dropdownValues: [String] {
    get { return parameters.dropdownValues }
    set {
      if parameters.dropdownValues != newValue {
        parameters.dropdownValues = newValue
      }
    }
  }

  public var onCloseDropdown: (() -> Void)? {
    get { return parameters.onCloseDropdown }
    set { parameters.onCloseDropdown = newValue }
  }

  public var onOpenDropdown: (() -> Void)? {
    get { return parameters.onOpenDropdown }
    set { parameters.onOpenDropdown = newValue }
  }

  public var detailView: CustomDetailView {
    get { return parameters.detailView }
    set {
      if parameters.detailView != newValue {
        parameters.detailView = newValue
      }
    }
  }

  public var onPressCommandUpKey: (() -> Void)? {
    get { return parameters.onPressCommandUpKey }
    set { parameters.onPressCommandUpKey = newValue }
  }

  public var onPressCommandDownKey: (() -> Void)? {
    get { return parameters.onPressCommandDownKey }
    set { parameters.onPressCommandDownKey = newValue }
  }

  public var showsDropdown: Bool {
    get { return parameters.showsDropdown }
    set {
      if parameters.showsDropdown != newValue {
        parameters.showsDropdown = newValue
      }
    }
  }

  public var suggestionFilter: SuggestionFilter {
    get { return parameters.suggestionFilter }
    set {
      if parameters.suggestionFilter != newValue {
        parameters.suggestionFilter = newValue
      }
    }
  }

  public var onPressFilterRecommended: (() -> Void)? {
    get { return parameters.onPressFilterRecommended }
    set { parameters.onPressFilterRecommended = newValue }
  }

  public var onPressFilterAll: (() -> Void)? {
    get { return parameters.onPressFilterAll }
    set { parameters.onPressFilterAll = newValue }
  }

  public var parameters: Parameters {
    didSet {
      if parameters != oldValue {
        update()
      }
    }
  }

  // MARK: Private

  private var searchAreaView = NSBox()
  private var searchInputContainerView = NSBox()
  private var searchInputView = ControlledSearchInput()
  private var controlledDropdownContainerView = NSBox()
  private var controlledDropdownView = ControlledDropdown()
  private var dividerView = NSBox()
  private var suggestionAreaView = NSBox()
  private var suggestionListContainerView = NSBox()
  private var suggestionListViewView = SuggestionListView()
  private var vDividerView = NSBox()
  private var detailAreaView = NSBox()
  private var suggestionDetailViewView = SuggestionDetailView()
  private var divider1View = NSBox()
  private var filterContainerView = NSBox()
  private var filterRecommendedView = FilterLabel()
  private var hSpacerView = NSBox()
  private var filterAllView = FilterLabel()

  private var searchInputContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownContainerViewLeadingAnchorSearchInputContainerViewTrailingAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownContainerViewTopAnchorSearchAreaViewTopAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownContainerViewBottomAnchorSearchAreaViewBottomAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownViewLeadingAnchorControlledDropdownContainerViewLeadingAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownViewTrailingAnchorControlledDropdownContainerViewTrailingAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownViewTopAnchorControlledDropdownContainerViewTopAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownViewCenterYAnchorControlledDropdownContainerViewCenterYAnchorConstraint: NSLayoutConstraint?
  private var controlledDropdownViewBottomAnchorControlledDropdownContainerViewBottomAnchorConstraint: NSLayoutConstraint?

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    searchAreaView.boxType = .custom
    searchAreaView.borderType = .noBorder
    searchAreaView.contentViewMargins = .zero
    dividerView.boxType = .custom
    dividerView.borderType = .noBorder
    dividerView.contentViewMargins = .zero
    suggestionAreaView.boxType = .custom
    suggestionAreaView.borderType = .noBorder
    suggestionAreaView.contentViewMargins = .zero
    divider1View.boxType = .custom
    divider1View.borderType = .noBorder
    divider1View.contentViewMargins = .zero
    filterContainerView.boxType = .custom
    filterContainerView.borderType = .noBorder
    filterContainerView.contentViewMargins = .zero
    searchInputContainerView.boxType = .custom
    searchInputContainerView.borderType = .noBorder
    searchInputContainerView.contentViewMargins = .zero
    controlledDropdownContainerView.boxType = .custom
    controlledDropdownContainerView.borderType = .noBorder
    controlledDropdownContainerView.contentViewMargins = .zero
    suggestionListContainerView.boxType = .custom
    suggestionListContainerView.borderType = .noBorder
    suggestionListContainerView.contentViewMargins = .zero
    vDividerView.boxType = .custom
    vDividerView.borderType = .noBorder
    vDividerView.contentViewMargins = .zero
    detailAreaView.boxType = .custom
    detailAreaView.borderType = .noBorder
    detailAreaView.contentViewMargins = .zero
    hSpacerView.boxType = .custom
    hSpacerView.borderType = .noBorder
    hSpacerView.contentViewMargins = .zero

    addSubview(searchAreaView)
    addSubview(dividerView)
    addSubview(suggestionAreaView)
    addSubview(divider1View)
    addSubview(filterContainerView)
    searchAreaView.addSubview(searchInputContainerView)
    searchAreaView.addSubview(controlledDropdownContainerView)
    searchInputContainerView.addSubview(searchInputView)
    controlledDropdownContainerView.addSubview(controlledDropdownView)
    suggestionAreaView.addSubview(suggestionListContainerView)
    suggestionAreaView.addSubview(vDividerView)
    suggestionAreaView.addSubview(detailAreaView)
    suggestionListContainerView.addSubview(suggestionListViewView)
    detailAreaView.addSubview(suggestionDetailViewView)
    filterContainerView.addSubview(filterRecommendedView)
    filterContainerView.addSubview(hSpacerView)
    filterContainerView.addSubview(filterAllView)

    dividerView.fillColor = Colors.divider
    vDividerView.fillColor = Colors.divider
    detailAreaView.fillColor = Colors.raisedBackground
    divider1View.fillColor = Colors.divider
    filterContainerView.fillColor = Colors.raisedBackground
    filterRecommendedView.titleText = "Recommended"
    filterAllView.titleText = "All"
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    searchAreaView.translatesAutoresizingMaskIntoConstraints = false
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    suggestionAreaView.translatesAutoresizingMaskIntoConstraints = false
    divider1View.translatesAutoresizingMaskIntoConstraints = false
    filterContainerView.translatesAutoresizingMaskIntoConstraints = false
    searchInputContainerView.translatesAutoresizingMaskIntoConstraints = false
    controlledDropdownContainerView.translatesAutoresizingMaskIntoConstraints = false
    searchInputView.translatesAutoresizingMaskIntoConstraints = false
    controlledDropdownView.translatesAutoresizingMaskIntoConstraints = false
    suggestionListContainerView.translatesAutoresizingMaskIntoConstraints = false
    vDividerView.translatesAutoresizingMaskIntoConstraints = false
    detailAreaView.translatesAutoresizingMaskIntoConstraints = false
    suggestionListViewView.translatesAutoresizingMaskIntoConstraints = false
    suggestionDetailViewView.translatesAutoresizingMaskIntoConstraints = false
    filterRecommendedView.translatesAutoresizingMaskIntoConstraints = false
    hSpacerView.translatesAutoresizingMaskIntoConstraints = false
    filterAllView.translatesAutoresizingMaskIntoConstraints = false

    let searchAreaViewTopAnchorConstraint = searchAreaView.topAnchor.constraint(equalTo: topAnchor)
    let searchAreaViewLeadingAnchorConstraint = searchAreaView.leadingAnchor.constraint(equalTo: leadingAnchor)
    let searchAreaViewTrailingAnchorConstraint = searchAreaView.trailingAnchor.constraint(equalTo: trailingAnchor)
    let dividerViewTopAnchorConstraint = dividerView.topAnchor.constraint(equalTo: searchAreaView.bottomAnchor)
    let dividerViewLeadingAnchorConstraint = dividerView.leadingAnchor.constraint(equalTo: leadingAnchor)
    let dividerViewTrailingAnchorConstraint = dividerView.trailingAnchor.constraint(equalTo: trailingAnchor)
    let suggestionAreaViewTopAnchorConstraint = suggestionAreaView
      .topAnchor
      .constraint(equalTo: dividerView.bottomAnchor)
    let suggestionAreaViewLeadingAnchorConstraint = suggestionAreaView.leadingAnchor.constraint(equalTo: leadingAnchor)
    let suggestionAreaViewTrailingAnchorConstraint = suggestionAreaView
      .trailingAnchor
      .constraint(equalTo: trailingAnchor)
    let divider1ViewTopAnchorConstraint = divider1View.topAnchor.constraint(equalTo: suggestionAreaView.bottomAnchor)
    let divider1ViewLeadingAnchorConstraint = divider1View.leadingAnchor.constraint(equalTo: leadingAnchor)
    let divider1ViewTrailingAnchorConstraint = divider1View.trailingAnchor.constraint(equalTo: trailingAnchor)
    let filterContainerViewBottomAnchorConstraint = filterContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    let filterContainerViewTopAnchorConstraint = filterContainerView
      .topAnchor
      .constraint(equalTo: divider1View.bottomAnchor)
    let filterContainerViewLeadingAnchorConstraint = filterContainerView
      .leadingAnchor
      .constraint(equalTo: leadingAnchor)
    let filterContainerViewTrailingAnchorConstraint = filterContainerView
      .trailingAnchor
      .constraint(equalTo: trailingAnchor)
    let searchAreaViewHeightAnchorConstraint = searchAreaView.heightAnchor.constraint(equalToConstant: 32)
    let searchInputContainerViewLeadingAnchorConstraint = searchInputContainerView
      .leadingAnchor
      .constraint(equalTo: searchAreaView.leadingAnchor)
    let searchInputContainerViewTopAnchorConstraint = searchInputContainerView
      .topAnchor
      .constraint(equalTo: searchAreaView.topAnchor)
    let searchInputContainerViewBottomAnchorConstraint = searchInputContainerView
      .bottomAnchor
      .constraint(equalTo: searchAreaView.bottomAnchor)
    let dividerViewHeightAnchorConstraint = dividerView.heightAnchor.constraint(equalToConstant: 1)
    let suggestionListContainerViewLeadingAnchorConstraint = suggestionListContainerView
      .leadingAnchor
      .constraint(equalTo: suggestionAreaView.leadingAnchor)
    let suggestionListContainerViewTopAnchorConstraint = suggestionListContainerView
      .topAnchor
      .constraint(equalTo: suggestionAreaView.topAnchor)
    let suggestionListContainerViewBottomAnchorConstraint = suggestionListContainerView
      .bottomAnchor
      .constraint(equalTo: suggestionAreaView.bottomAnchor)
    let vDividerViewLeadingAnchorConstraint = vDividerView
      .leadingAnchor
      .constraint(equalTo: suggestionListContainerView.trailingAnchor)
    let vDividerViewTopAnchorConstraint = vDividerView.topAnchor.constraint(equalTo: suggestionAreaView.topAnchor)
    let vDividerViewBottomAnchorConstraint = vDividerView
      .bottomAnchor
      .constraint(equalTo: suggestionAreaView.bottomAnchor)
    let detailAreaViewTrailingAnchorConstraint = detailAreaView
      .trailingAnchor
      .constraint(equalTo: suggestionAreaView.trailingAnchor)
    let detailAreaViewLeadingAnchorConstraint = detailAreaView
      .leadingAnchor
      .constraint(equalTo: vDividerView.trailingAnchor)
    let detailAreaViewTopAnchorConstraint = detailAreaView.topAnchor.constraint(equalTo: suggestionAreaView.topAnchor)
    let detailAreaViewBottomAnchorConstraint = detailAreaView
      .bottomAnchor
      .constraint(equalTo: suggestionAreaView.bottomAnchor)
    let divider1ViewHeightAnchorConstraint = divider1View.heightAnchor.constraint(equalToConstant: 1)
    let filterRecommendedViewHeightAnchorParentConstraint = filterRecommendedView
      .heightAnchor
      .constraint(lessThanOrEqualTo: filterContainerView.heightAnchor, constant: -8)
    let hSpacerViewHeightAnchorParentConstraint = hSpacerView
      .heightAnchor
      .constraint(lessThanOrEqualTo: filterContainerView.heightAnchor, constant: -8)
    let filterAllViewHeightAnchorParentConstraint = filterAllView
      .heightAnchor
      .constraint(lessThanOrEqualTo: filterContainerView.heightAnchor, constant: -8)
    let filterRecommendedViewLeadingAnchorConstraint = filterRecommendedView
      .leadingAnchor
      .constraint(equalTo: filterContainerView.leadingAnchor, constant: 4)
    let filterRecommendedViewTopAnchorConstraint = filterRecommendedView
      .topAnchor
      .constraint(equalTo: filterContainerView.topAnchor, constant: 4)
    let filterRecommendedViewBottomAnchorConstraint = filterRecommendedView
      .bottomAnchor
      .constraint(equalTo: filterContainerView.bottomAnchor, constant: -4)
    let hSpacerViewLeadingAnchorConstraint = hSpacerView
      .leadingAnchor
      .constraint(equalTo: filterRecommendedView.trailingAnchor)
    let hSpacerViewTopAnchorConstraint = hSpacerView
      .topAnchor
      .constraint(equalTo: filterContainerView.topAnchor, constant: 4)
    let hSpacerViewBottomAnchorConstraint = hSpacerView
      .bottomAnchor
      .constraint(equalTo: filterContainerView.bottomAnchor, constant: -4)
    let filterAllViewLeadingAnchorConstraint = filterAllView
      .leadingAnchor
      .constraint(equalTo: hSpacerView.trailingAnchor)
    let filterAllViewTopAnchorConstraint = filterAllView
      .topAnchor
      .constraint(equalTo: filterContainerView.topAnchor, constant: 4)
    let filterAllViewBottomAnchorConstraint = filterAllView
      .bottomAnchor
      .constraint(equalTo: filterContainerView.bottomAnchor, constant: -4)
    let searchInputViewTopAnchorConstraint = searchInputView
      .topAnchor
      .constraint(equalTo: searchInputContainerView.topAnchor, constant: 5)
    let searchInputViewBottomAnchorConstraint = searchInputView
      .bottomAnchor
      .constraint(equalTo: searchInputContainerView.bottomAnchor, constant: -5)
    let searchInputViewLeadingAnchorConstraint = searchInputView
      .leadingAnchor
      .constraint(equalTo: searchInputContainerView.leadingAnchor, constant: 10)
    let searchInputViewTrailingAnchorConstraint = searchInputView
      .trailingAnchor
      .constraint(equalTo: searchInputContainerView.trailingAnchor, constant: -10)
    let suggestionListContainerViewWidthAnchorConstraint = suggestionListContainerView
      .widthAnchor
      .constraint(equalToConstant: 200)
    let suggestionListViewViewTopAnchorConstraint = suggestionListViewView
      .topAnchor
      .constraint(equalTo: suggestionListContainerView.topAnchor)
    let suggestionListViewViewBottomAnchorConstraint = suggestionListViewView
      .bottomAnchor
      .constraint(equalTo: suggestionListContainerView.bottomAnchor)
    let suggestionListViewViewLeadingAnchorConstraint = suggestionListViewView
      .leadingAnchor
      .constraint(equalTo: suggestionListContainerView.leadingAnchor)
    let suggestionListViewViewTrailingAnchorConstraint = suggestionListViewView
      .trailingAnchor
      .constraint(equalTo: suggestionListContainerView.trailingAnchor)
    let vDividerViewWidthAnchorConstraint = vDividerView.widthAnchor.constraint(equalToConstant: 1)
    let suggestionDetailViewViewTopAnchorConstraint = suggestionDetailViewView
      .topAnchor
      .constraint(equalTo: detailAreaView.topAnchor)
    let suggestionDetailViewViewBottomAnchorConstraint = suggestionDetailViewView
      .bottomAnchor
      .constraint(equalTo: detailAreaView.bottomAnchor)
    let suggestionDetailViewViewLeadingAnchorConstraint = suggestionDetailViewView
      .leadingAnchor
      .constraint(equalTo: detailAreaView.leadingAnchor)
    let suggestionDetailViewViewTrailingAnchorConstraint = suggestionDetailViewView
      .trailingAnchor
      .constraint(equalTo: detailAreaView.trailingAnchor)
    let hSpacerViewWidthAnchorConstraint = hSpacerView.widthAnchor.constraint(equalToConstant: 4)
    let searchInputContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint = searchInputContainerView
      .trailingAnchor
      .constraint(equalTo: searchAreaView.trailingAnchor)
    let controlledDropdownContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint = controlledDropdownContainerView
      .trailingAnchor
      .constraint(equalTo: searchAreaView.trailingAnchor)
    let controlledDropdownContainerViewLeadingAnchorSearchInputContainerViewTrailingAnchorConstraint = controlledDropdownContainerView
      .leadingAnchor
      .constraint(equalTo: searchInputContainerView.trailingAnchor)
    let controlledDropdownContainerViewTopAnchorSearchAreaViewTopAnchorConstraint = controlledDropdownContainerView
      .topAnchor
      .constraint(equalTo: searchAreaView.topAnchor)
    let controlledDropdownContainerViewBottomAnchorSearchAreaViewBottomAnchorConstraint = controlledDropdownContainerView
      .bottomAnchor
      .constraint(equalTo: searchAreaView.bottomAnchor)
    let controlledDropdownViewLeadingAnchorControlledDropdownContainerViewLeadingAnchorConstraint = controlledDropdownView
      .leadingAnchor
      .constraint(equalTo: controlledDropdownContainerView.leadingAnchor, constant: 5)
    let controlledDropdownViewTrailingAnchorControlledDropdownContainerViewTrailingAnchorConstraint = controlledDropdownView
      .trailingAnchor
      .constraint(equalTo: controlledDropdownContainerView.trailingAnchor, constant: -5)
    let controlledDropdownViewTopAnchorControlledDropdownContainerViewTopAnchorConstraint = controlledDropdownView
      .topAnchor
      .constraint(greaterThanOrEqualTo: controlledDropdownContainerView.topAnchor)
    let controlledDropdownViewCenterYAnchorControlledDropdownContainerViewCenterYAnchorConstraint = controlledDropdownView
      .centerYAnchor
      .constraint(equalTo: controlledDropdownContainerView.centerYAnchor)
    let controlledDropdownViewBottomAnchorControlledDropdownContainerViewBottomAnchorConstraint = controlledDropdownView
      .bottomAnchor
      .constraint(lessThanOrEqualTo: controlledDropdownContainerView.bottomAnchor)

    filterRecommendedViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow
    hSpacerViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow
    filterAllViewHeightAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow

    self.searchInputContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint =
      searchInputContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint
    self.controlledDropdownContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint =
      controlledDropdownContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint
    self.controlledDropdownContainerViewLeadingAnchorSearchInputContainerViewTrailingAnchorConstraint =
      controlledDropdownContainerViewLeadingAnchorSearchInputContainerViewTrailingAnchorConstraint
    self.controlledDropdownContainerViewTopAnchorSearchAreaViewTopAnchorConstraint =
      controlledDropdownContainerViewTopAnchorSearchAreaViewTopAnchorConstraint
    self.controlledDropdownContainerViewBottomAnchorSearchAreaViewBottomAnchorConstraint =
      controlledDropdownContainerViewBottomAnchorSearchAreaViewBottomAnchorConstraint
    self.controlledDropdownViewLeadingAnchorControlledDropdownContainerViewLeadingAnchorConstraint =
      controlledDropdownViewLeadingAnchorControlledDropdownContainerViewLeadingAnchorConstraint
    self.controlledDropdownViewTrailingAnchorControlledDropdownContainerViewTrailingAnchorConstraint =
      controlledDropdownViewTrailingAnchorControlledDropdownContainerViewTrailingAnchorConstraint
    self.controlledDropdownViewTopAnchorControlledDropdownContainerViewTopAnchorConstraint =
      controlledDropdownViewTopAnchorControlledDropdownContainerViewTopAnchorConstraint
    self.controlledDropdownViewCenterYAnchorControlledDropdownContainerViewCenterYAnchorConstraint =
      controlledDropdownViewCenterYAnchorControlledDropdownContainerViewCenterYAnchorConstraint
    self.controlledDropdownViewBottomAnchorControlledDropdownContainerViewBottomAnchorConstraint =
      controlledDropdownViewBottomAnchorControlledDropdownContainerViewBottomAnchorConstraint

    NSLayoutConstraint.activate(
      [
        searchAreaViewTopAnchorConstraint,
        searchAreaViewLeadingAnchorConstraint,
        searchAreaViewTrailingAnchorConstraint,
        dividerViewTopAnchorConstraint,
        dividerViewLeadingAnchorConstraint,
        dividerViewTrailingAnchorConstraint,
        suggestionAreaViewTopAnchorConstraint,
        suggestionAreaViewLeadingAnchorConstraint,
        suggestionAreaViewTrailingAnchorConstraint,
        divider1ViewTopAnchorConstraint,
        divider1ViewLeadingAnchorConstraint,
        divider1ViewTrailingAnchorConstraint,
        filterContainerViewBottomAnchorConstraint,
        filterContainerViewTopAnchorConstraint,
        filterContainerViewLeadingAnchorConstraint,
        filterContainerViewTrailingAnchorConstraint,
        searchAreaViewHeightAnchorConstraint,
        searchInputContainerViewLeadingAnchorConstraint,
        searchInputContainerViewTopAnchorConstraint,
        searchInputContainerViewBottomAnchorConstraint,
        dividerViewHeightAnchorConstraint,
        suggestionListContainerViewLeadingAnchorConstraint,
        suggestionListContainerViewTopAnchorConstraint,
        suggestionListContainerViewBottomAnchorConstraint,
        vDividerViewLeadingAnchorConstraint,
        vDividerViewTopAnchorConstraint,
        vDividerViewBottomAnchorConstraint,
        detailAreaViewTrailingAnchorConstraint,
        detailAreaViewLeadingAnchorConstraint,
        detailAreaViewTopAnchorConstraint,
        detailAreaViewBottomAnchorConstraint,
        divider1ViewHeightAnchorConstraint,
        filterRecommendedViewHeightAnchorParentConstraint,
        hSpacerViewHeightAnchorParentConstraint,
        filterAllViewHeightAnchorParentConstraint,
        filterRecommendedViewLeadingAnchorConstraint,
        filterRecommendedViewTopAnchorConstraint,
        filterRecommendedViewBottomAnchorConstraint,
        hSpacerViewLeadingAnchorConstraint,
        hSpacerViewTopAnchorConstraint,
        hSpacerViewBottomAnchorConstraint,
        filterAllViewLeadingAnchorConstraint,
        filterAllViewTopAnchorConstraint,
        filterAllViewBottomAnchorConstraint,
        searchInputViewTopAnchorConstraint,
        searchInputViewBottomAnchorConstraint,
        searchInputViewLeadingAnchorConstraint,
        searchInputViewTrailingAnchorConstraint,
        suggestionListContainerViewWidthAnchorConstraint,
        suggestionListViewViewTopAnchorConstraint,
        suggestionListViewViewBottomAnchorConstraint,
        suggestionListViewViewLeadingAnchorConstraint,
        suggestionListViewViewTrailingAnchorConstraint,
        vDividerViewWidthAnchorConstraint,
        suggestionDetailViewViewTopAnchorConstraint,
        suggestionDetailViewViewBottomAnchorConstraint,
        suggestionDetailViewViewLeadingAnchorConstraint,
        suggestionDetailViewViewTrailingAnchorConstraint,
        hSpacerViewWidthAnchorConstraint
      ] +
        conditionalConstraints(controlledDropdownContainerViewIsHidden: controlledDropdownContainerView.isHidden))
  }

  private func conditionalConstraints(controlledDropdownContainerViewIsHidden: Bool) -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint?]

    switch (controlledDropdownContainerViewIsHidden) {
      case (true):
        constraints = [searchInputContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint]
      case (false):
        constraints = [
          controlledDropdownContainerViewTrailingAnchorSearchAreaViewTrailingAnchorConstraint,
          controlledDropdownContainerViewLeadingAnchorSearchInputContainerViewTrailingAnchorConstraint,
          controlledDropdownContainerViewTopAnchorSearchAreaViewTopAnchorConstraint,
          controlledDropdownContainerViewBottomAnchorSearchAreaViewBottomAnchorConstraint,
          controlledDropdownViewLeadingAnchorControlledDropdownContainerViewLeadingAnchorConstraint,
          controlledDropdownViewTrailingAnchorControlledDropdownContainerViewTrailingAnchorConstraint,
          controlledDropdownViewTopAnchorControlledDropdownContainerViewTopAnchorConstraint,
          controlledDropdownViewCenterYAnchorControlledDropdownContainerViewCenterYAnchorConstraint,
          controlledDropdownViewBottomAnchorControlledDropdownContainerViewBottomAnchorConstraint
        ]
    }

    return constraints.compactMap({ $0 })
  }

  private func update() {
    let controlledDropdownContainerViewIsHidden = controlledDropdownContainerView.isHidden

    filterAllView.isActive = false
    filterRecommendedView.isActive = false
    searchInputView.onChangeTextValue = handleOnChangeSearchText
    searchInputView.textValue = searchText
    searchInputView.placeholderText = placeholderText
    searchInputView.onPressDownKey = handleOnPressDownKey
    searchInputView.onPressUpKey = handleOnPressUpKey
    suggestionListViewView.selectedIndex = selectedIndex
    suggestionListViewView.onSelectIndex = handleOnSelectIndex
    suggestionListViewView.onActivateIndex = handleOnActivateIndex
    searchInputView.onSubmit = handleOnSubmit
    searchInputView.onPressEscape = handleOnPressEscapeKey
    searchInputView.onPressTab = handleOnPressTabKey
    searchInputView.onPressShiftTab = handleOnPressShiftTabKey
    controlledDropdownView.onChangeIndex = handleOnSelectDropdownIndex
    controlledDropdownContainerView.isHidden = !showsDropdown
    controlledDropdownView.values = dropdownValues
    controlledDropdownView.selectedIndex = dropdownIndex
    controlledDropdownView.onHighlightIndex = handleOnHighlightDropdownIndex
    controlledDropdownView.onCloseMenu = handleOnCloseDropdown
    controlledDropdownView.onOpenMenu = handleOnOpenDropdown
    suggestionDetailViewView.detailView = detailView
    searchInputView.onPressCommandDownKey = handleOnPressCommandDownKey
    searchInputView.onPressCommandUpKey = handleOnPressCommandUpKey
    filterAllView.onClick = handleOnPressFilterAll
    filterRecommendedView.onClick = handleOnPressFilterRecommended
    if suggestionFilter == .recommended {
      filterRecommendedView.isActive = true
    }
    if suggestionFilter == .all {
      filterAllView.isActive = true
    }

    if controlledDropdownContainerView.isHidden != controlledDropdownContainerViewIsHidden {
      NSLayoutConstraint.deactivate(
        conditionalConstraints(controlledDropdownContainerViewIsHidden: controlledDropdownContainerViewIsHidden))
      NSLayoutConstraint.activate(
        conditionalConstraints(controlledDropdownContainerViewIsHidden: controlledDropdownContainerView.isHidden))
    }
  }

  private func handleOnChangeSearchText(_ arg0: String) {
    onChangeSearchText?(arg0)
  }

  private func handleOnPressDownKey() {
    onPressDownKey?()
  }

  private func handleOnPressUpKey() {
    onPressUpKey?()
  }

  private func handleOnSelectIndex(_ arg0: Int?) {
    onSelectIndex?(arg0)
  }

  private func handleOnActivateIndex(_ arg0: Int) {
    onActivateIndex?(arg0)
  }

  private func handleOnSubmit() {
    onSubmit?()
  }

  private func handleOnPressTabKey() {
    onPressTabKey?()
  }

  private func handleOnPressShiftTabKey() {
    onPressShiftTabKey?()
  }

  private func handleOnPressEscapeKey() {
    onPressEscapeKey?()
  }

  private func handleOnSelectDropdownIndex(_ arg0: Int) {
    onSelectDropdownIndex?(arg0)
  }

  private func handleOnHighlightDropdownIndex(_ arg0: Int?) {
    onHighlightDropdownIndex?(arg0)
  }

  private func handleOnCloseDropdown() {
    onCloseDropdown?()
  }

  private func handleOnOpenDropdown() {
    onOpenDropdown?()
  }

  private func handleOnPressCommandUpKey() {
    onPressCommandUpKey?()
  }

  private func handleOnPressCommandDownKey() {
    onPressCommandDownKey?()
  }

  private func handleOnPressFilterRecommended() {
    onPressFilterRecommended?()
  }

  private func handleOnPressFilterAll() {
    onPressFilterAll?()
  }
}

// MARK: - Parameters

extension SuggestionView {
  public struct Parameters: Equatable {
    public var searchText: String
    public var placeholderText: String?
    public var selectedIndex: Int?
    public var dropdownIndex: Int
    public var dropdownValues: [String]
    public var detailView: CustomDetailView
    public var showsDropdown: Bool
    public var suggestionFilter: SuggestionFilter
    public var onChangeSearchText: ((String) -> Void)?
    public var onPressDownKey: (() -> Void)?
    public var onPressUpKey: (() -> Void)?
    public var onSelectIndex: ((Int?) -> Void)?
    public var onActivateIndex: ((Int) -> Void)?
    public var onSubmit: (() -> Void)?
    public var onPressTabKey: (() -> Void)?
    public var onPressShiftTabKey: (() -> Void)?
    public var onPressEscapeKey: (() -> Void)?
    public var onSelectDropdownIndex: ((Int) -> Void)?
    public var onHighlightDropdownIndex: ((Int?) -> Void)?
    public var onCloseDropdown: (() -> Void)?
    public var onOpenDropdown: (() -> Void)?
    public var onPressCommandUpKey: (() -> Void)?
    public var onPressCommandDownKey: (() -> Void)?
    public var onPressFilterRecommended: (() -> Void)?
    public var onPressFilterAll: (() -> Void)?

    public init(
      searchText: String,
      placeholderText: String? = nil,
      selectedIndex: Int? = nil,
      dropdownIndex: Int,
      dropdownValues: [String],
      detailView: CustomDetailView,
      showsDropdown: Bool,
      suggestionFilter: SuggestionFilter,
      onChangeSearchText: ((String) -> Void)? = nil,
      onPressDownKey: (() -> Void)? = nil,
      onPressUpKey: (() -> Void)? = nil,
      onSelectIndex: ((Int?) -> Void)? = nil,
      onActivateIndex: ((Int) -> Void)? = nil,
      onSubmit: (() -> Void)? = nil,
      onPressTabKey: (() -> Void)? = nil,
      onPressShiftTabKey: (() -> Void)? = nil,
      onPressEscapeKey: (() -> Void)? = nil,
      onSelectDropdownIndex: ((Int) -> Void)? = nil,
      onHighlightDropdownIndex: ((Int?) -> Void)? = nil,
      onCloseDropdown: (() -> Void)? = nil,
      onOpenDropdown: (() -> Void)? = nil,
      onPressCommandUpKey: (() -> Void)? = nil,
      onPressCommandDownKey: (() -> Void)? = nil,
      onPressFilterRecommended: (() -> Void)? = nil,
      onPressFilterAll: (() -> Void)? = nil)
    {
      self.searchText = searchText
      self.placeholderText = placeholderText
      self.selectedIndex = selectedIndex
      self.dropdownIndex = dropdownIndex
      self.dropdownValues = dropdownValues
      self.detailView = detailView
      self.showsDropdown = showsDropdown
      self.suggestionFilter = suggestionFilter
      self.onChangeSearchText = onChangeSearchText
      self.onPressDownKey = onPressDownKey
      self.onPressUpKey = onPressUpKey
      self.onSelectIndex = onSelectIndex
      self.onActivateIndex = onActivateIndex
      self.onSubmit = onSubmit
      self.onPressTabKey = onPressTabKey
      self.onPressShiftTabKey = onPressShiftTabKey
      self.onPressEscapeKey = onPressEscapeKey
      self.onSelectDropdownIndex = onSelectDropdownIndex
      self.onHighlightDropdownIndex = onHighlightDropdownIndex
      self.onCloseDropdown = onCloseDropdown
      self.onOpenDropdown = onOpenDropdown
      self.onPressCommandUpKey = onPressCommandUpKey
      self.onPressCommandDownKey = onPressCommandDownKey
      self.onPressFilterRecommended = onPressFilterRecommended
      self.onPressFilterAll = onPressFilterAll
    }

    public init() {
      self
        .init(
          searchText: "",
          placeholderText: nil,
          selectedIndex: nil,
          dropdownIndex: 0,
          dropdownValues: [],
          detailView: nil,
          showsDropdown: false,
          suggestionFilter: .recommended)
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.searchText == rhs.searchText &&
        lhs.placeholderText == rhs.placeholderText &&
          lhs.selectedIndex == rhs.selectedIndex &&
            lhs.dropdownIndex == rhs.dropdownIndex &&
              lhs.dropdownValues == rhs.dropdownValues &&
                lhs.detailView == rhs.detailView &&
                  lhs.showsDropdown == rhs.showsDropdown && lhs.suggestionFilter == rhs.suggestionFilter
    }
  }
}

// MARK: - Model

extension SuggestionView {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "SuggestionView"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(
      searchText: String,
      placeholderText: String? = nil,
      selectedIndex: Int? = nil,
      dropdownIndex: Int,
      dropdownValues: [String],
      detailView: CustomDetailView,
      showsDropdown: Bool,
      suggestionFilter: SuggestionFilter,
      onChangeSearchText: ((String) -> Void)? = nil,
      onPressDownKey: (() -> Void)? = nil,
      onPressUpKey: (() -> Void)? = nil,
      onSelectIndex: ((Int?) -> Void)? = nil,
      onActivateIndex: ((Int) -> Void)? = nil,
      onSubmit: (() -> Void)? = nil,
      onPressTabKey: (() -> Void)? = nil,
      onPressShiftTabKey: (() -> Void)? = nil,
      onPressEscapeKey: (() -> Void)? = nil,
      onSelectDropdownIndex: ((Int) -> Void)? = nil,
      onHighlightDropdownIndex: ((Int?) -> Void)? = nil,
      onCloseDropdown: (() -> Void)? = nil,
      onOpenDropdown: (() -> Void)? = nil,
      onPressCommandUpKey: (() -> Void)? = nil,
      onPressCommandDownKey: (() -> Void)? = nil,
      onPressFilterRecommended: (() -> Void)? = nil,
      onPressFilterAll: (() -> Void)? = nil)
    {
      self
        .init(
          Parameters(
            searchText: searchText,
            placeholderText: placeholderText,
            selectedIndex: selectedIndex,
            dropdownIndex: dropdownIndex,
            dropdownValues: dropdownValues,
            detailView: detailView,
            showsDropdown: showsDropdown,
            suggestionFilter: suggestionFilter,
            onChangeSearchText: onChangeSearchText,
            onPressDownKey: onPressDownKey,
            onPressUpKey: onPressUpKey,
            onSelectIndex: onSelectIndex,
            onActivateIndex: onActivateIndex,
            onSubmit: onSubmit,
            onPressTabKey: onPressTabKey,
            onPressShiftTabKey: onPressShiftTabKey,
            onPressEscapeKey: onPressEscapeKey,
            onSelectDropdownIndex: onSelectDropdownIndex,
            onHighlightDropdownIndex: onHighlightDropdownIndex,
            onCloseDropdown: onCloseDropdown,
            onOpenDropdown: onOpenDropdown,
            onPressCommandUpKey: onPressCommandUpKey,
            onPressCommandDownKey: onPressCommandDownKey,
            onPressFilterRecommended: onPressFilterRecommended,
            onPressFilterAll: onPressFilterAll))
    }

    public init() {
      self
        .init(
          searchText: "",
          placeholderText: nil,
          selectedIndex: nil,
          dropdownIndex: 0,
          dropdownValues: [],
          detailView: nil,
          showsDropdown: false,
          suggestionFilter: .recommended)
    }
  }
}

// MARK: - SuggestionFilter

extension SuggestionView {
  public enum SuggestionFilter: Codable, Equatable {
    case recommended
    case all

    // MARK: Codable

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let type = try container.decode(Bool.self)

      switch type {
        case false:
          self = .recommended
        case true:
          self = .all
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()

      switch self {
        case .recommended:
          try container.encode(false)
        case .all:
          try container.encode(true)
      }
    }
  }
}

// LONA: KEEP BELOW

extension SuggestionView {
    public var searchInput: ControlledSearchInput {
        return searchInputView
    }

    public var suggestionList: SuggestionListView {
        return suggestionListViewView
    }
}
