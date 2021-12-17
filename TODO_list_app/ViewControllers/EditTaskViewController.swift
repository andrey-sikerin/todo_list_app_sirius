import UIKit
import RxSwift

class EditTaskViewController: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let textView = UITextView()
    private let stackView = UIStackView()
    private let button = UIButton()
    private let notificationCenter: NotificationCenter

    private lazy var priorityStackViewContainer: PriorityStackViewContainer = {
        PriorityStackViewContainer(
            viewModel: viewModel.priorityContainer,
            frame: .zero,
            layout: PriorityStackViewContainer.LayoutStyles(
                itemCornerRadius: LayoutStyles.defaultStyle.itemsBorderRadius,
                labelLeftPadding: LayoutStyles.defaultStyle.labelLeftPadding,
                segmentControlRightPadding: LayoutStyles.defaultStyle.segmentControlRightPadding,
                segmentControlHeight: LayoutStyles.defaultStyle.segmentControlHeight,
                segmentControlWidth: LayoutStyles.defaultStyle.segmentControlWidth)
        )
    }()
    private let line = UIView()
    private let secondaryLabel = UILabel()
    private let datePicker = UIDatePicker()

    private let styles: Styles
    private let layoutStyles: LayoutStyles
    private let strings: Strings

    private var showPlaceholder = true
    private var keyboardHeight: CGFloat = 0

    public struct Strings {
        let leftNavigationBarText: String
        let rightNavigationBarText: String
        let titleNavigationBarText: String
        let textViewPlaceholder: String
        let buttonText: String
        let doBeforeText: String
    }

    struct LayoutStyles {
        let contentInsets: UIEdgeInsets
        let textSize: CGFloat

        let textViewDefaultHeight: CGFloat = 120
        let textViewInnerPadding: CGFloat = 16

        let itemsBorderRadius: CGFloat
        let itemsBackgroundColor: UIColor
        let itemsVerticalMargin: CGFloat = 16
        let buttonHeight: CGFloat
        let stackViewHeight: CGFloat

        let lineLeftPadding: CGFloat
        let lineRightPadding: CGFloat
        let lineHeight: CGFloat

        let labelLeftPadding: CGFloat

        let segmentControlRightPadding: CGFloat
        let segmentControlHeight: CGFloat
        let segmentControlWidth: CGFloat

        let labelsLeadingOffset: CGFloat = 16
        let switcherTrailingOffset: CGFloat = 12
        let primaryLabelFontSize: CGFloat = 17
        let secondaryLabelFontSize: CGFloat = 13
        let datePickerHeight: CGFloat = 340
    }

    public struct Styles {
        let lineOpacity: CGFloat = 0.2
        var itemsBackground: UIColor
        var backgroundColor: UIColor
        var textViewTextColor: UIColor
        var textViewPlaceholderColor: UIColor
        let buttonTextColor: UIColor
        let buttonPressedTextColor: UIColor
        let showingCancelButton: Bool
    }

    private lazy var deadLineStackViewContainer: DeadLineStackViewContainer = {
        let container = DeadLineStackViewContainer(viewModel: viewModel.deadlineContainer) { [weak self] isOn in
            self?.switcherTapped(isOn)
        } toggleCalendar: { [weak self] in
            self?.toggleCalendar()
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private var viewModel: EditTaskViewModel

    init(viewModel: EditTaskViewModel, notificationCenter: NotificationCenter, strings: Strings, styles: Styles, layoutStyles: LayoutStyles = .defaultStyle) {
        self.viewModel = viewModel
        self.strings = strings
        self.styles = styles
        self.layoutStyles = layoutStyles
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTouchScreen))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)

        view.backgroundColor = styles.backgroundColor

        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.showPlaceholder.subscribe(onNext: { [weak self] showPlaceholder in
            self?.showPlaceholder = showPlaceholder
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

        if styles.showingCancelButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: strings.leftNavigationBarText,
                style: .plain,
                target: self,
                action: #selector(onLeftBarButtonClicked)
            )
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: strings.rightNavigationBarText,
                style: .plain,
                target: self,
                action: #selector(onRightBarButtonClicked)
        )
        navigationItem.title = strings.titleNavigationBarText

        let innerPadding = layoutStyles.textViewInnerPadding
        textView.textContainerInset = UIEdgeInsets(
                top: innerPadding, left: innerPadding, bottom: innerPadding, right: innerPadding
        )
        
        viewModel.text.subscribe(onNext: { [weak self] text in
            self?.textView.text = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        textView.text = try! viewModel.showPlaceholder.value() ? strings.textViewPlaceholder : viewModel.text.value()
        textView.font = .systemFont(ofSize: layoutStyles.textSize)
        textView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        textView.backgroundColor = styles.itemsBackground
        textView.textColor = try! viewModel.showPlaceholder.value() ? styles.textViewPlaceholderColor : styles.textViewTextColor
        textView.isScrollEnabled = false
        textView.delegate = self

        let smallStackViewHeight: CGFloat = (layoutStyles.stackViewHeight - layoutStyles.lineHeight) / 2

        setupScrollView()
        setupStackView()
        setupPriorityStackViewContainer(smallStackViewHeight)
        setupDeadLineStackViewContainer(smallStackViewHeight)
        setupButton()
        setupDatePicker()
        setupLine()
        notificationCenter.addObserver(self,
                selector: #selector(onKeyboardOpened(keyboardShowNotification:)),
                name: UIResponder.keyboardDidShowNotification,
                object: nil)
    }

    @objc func datePicked(sender: UIDatePicker) {
        viewModel.selectNewDate(datePicker.date)
//        selectedDate = datePicker.date
    }

    @objc func onKeyboardOpened(keyboardShowNotification notification: Notification) {
        changeTextViewSize(canStretchIndefinitely: false, withAnimation: true)
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardRectangle.height
        }
    }

    @objc func onButtonPress() {
        print("Button pressed")
    }

    @objc func onTouchScreen(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
        changeTextViewSize(canStretchIndefinitely: true, withAnimation: true)
        setItemsLayout()
    }

    @objc func onRightBarButtonClicked() {
        textView.resignFirstResponder()
    }

    @objc func onLeftBarButtonClicked() {
        viewModel.transitionAction()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = styles.textViewTextColor
        if (showPlaceholder) {
            textView.text = ""
            textView.textColor = styles.textViewTextColor
        }
    }

    private func toggleCalendar() {
//        deadLineStackViewContainer.switcher.isOn = deadLineStackViewContainer.switcher.isOn || showingDatePicker
        viewModel.toggleCalendar(with: datePicker.date)
        setItemsLayout()
    }

    private func switcherTapped(_ isOn: Bool) {
        viewModel.switcherTapped(isOn: isOn, date: datePicker.date)
        setItemsLayout()
    }
    
    private let disposeBag = DisposeBag()
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.calendar = .autoupdatingCurrent
        datePicker.isHidden = true
        viewModel.showingDatePicker.subscribe(onNext: {
            [weak self] showDatePicker in
            self?.datePicker.isHidden = !showDatePicker
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        datePicker.addTarget(self, action: #selector(datePicked), for: .allEvents)
    }

    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(textView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(button)
        view.addSubview(scrollView)
    }

    private func setupButton() {
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = layoutStyles.itemsBorderRadius
        button.backgroundColor = styles.itemsBackground
        button.setTitleColor(styles.buttonTextColor, for: .normal)
        button.setTitleColor(styles.buttonPressedTextColor, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: layoutStyles.textSize)
        button.setTitle(strings.buttonText, for: .normal)
    }

    private func setupDeadLineStackViewContainer(_ smallStackViewHeight: CGFloat) {
        deadLineStackViewContainer.layer.cornerRadius = layoutStyles.itemsBorderRadius
        deadLineStackViewContainer.heightAnchor.constraint(equalToConstant: smallStackViewHeight).isActive = true
        deadLineStackViewContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0).isActive = true
        deadLineStackViewContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0).isActive = true
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.autoresizingMask = []
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        stackView.backgroundColor = styles.itemsBackground
        stackView.addArrangedSubview(priorityStackViewContainer)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(deadLineStackViewContainer)
        stackView.addArrangedSubview(datePicker)
    }

    private func setupPriorityStackViewContainer(_ smallStackViewHeight: CGFloat) {
        priorityStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        priorityStackViewContainer.layer.cornerRadius = layoutStyles.itemsBorderRadius
        priorityStackViewContainer.heightAnchor.constraint(equalToConstant: smallStackViewHeight).isActive = true
        priorityStackViewContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0).isActive = true
        priorityStackViewContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0).isActive = true
    }

    private func setupLine() {
        line.backgroundColor = Color.separator
        line.heightAnchor.constraint(equalToConstant: layoutStyles.lineHeight).isActive = true
        line.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: layoutStyles.lineLeftPadding).isActive = true
        line.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: layoutStyles.lineRightPadding).isActive = true
    }

    private func changeTextViewSize(canStretchIndefinitely: Bool, withAnimation: Bool = false) {
        let textViewAvailableHeight = view.frame.height - scrollView.contentInset.bottom -
                scrollView.contentInset.top - keyboardHeight - 2 * layoutStyles.itemsVerticalMargin

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        let currentTextViewHeight = max(newSize.height, layoutStyles.textViewDefaultHeight)

        var height: CGFloat
        if currentTextViewHeight > textViewAvailableHeight && !canStretchIndefinitely {
            height = textViewAvailableHeight
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            height = currentTextViewHeight
        }

        newFrame.size = CGSize(
                width: max(newSize.width, fixedWidth),
                height: height
        )
        newFrame.origin = .zero

        UIView.animateKeyframes(
                withDuration: withAnimation ? 0.5 : 0,
                delay: 0,
                options: [],
                animations: {
                    self.textView.frame = newFrame
                }, completion: nil)
        textView.scrollRangeToVisible(textView.selectedRange)
        setItemsLayout()
    }


    func textViewDidChange(_ textView: UITextView) {
        changeTextViewSize(canStretchIndefinitely: false)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            showPlaceholder = true
            textView.text = strings.textViewPlaceholder
            textView.textColor = styles.textViewPlaceholderColor
        } else {
            showPlaceholder = false
        }
    }

    private func setItemsLayout() {
        let editTaskItemsLayout = EditTaskItemsLayout(
                contentSize: scrollView.contentSize,
                stackViewHeight: layoutStyles.stackViewHeight,
                buttonHeight: layoutStyles.buttonHeight,
                textViewHeight: textView.bounds.height,
                datePickerHeight: !datePicker.isHidden ? layoutStyles.datePickerHeight : 0,
                itemsMargin: layoutStyles.itemsVerticalMargin,
                boundsMinX: scrollView.bounds.minX,
                boundsHeight: scrollView.bounds.size.height,
                contentInsetBottom: scrollView.contentInset.bottom
        )


        stackView.frame = editTaskItemsLayout.stackViewFrame
        button.frame = editTaskItemsLayout.buttonFrame
        scrollView.contentSize.height = editTaskItemsLayout.contentSizeHeight

        if (view.frame.size.height <= editTaskItemsLayout.contentSizeHeight) {
            scrollView.setContentOffset(editTaskItemsLayout.contentOffset, animated: true)
        }

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width,
                height: view.frame.height)

        var customSafeAreaInsets = view.safeAreaInsets
        customSafeAreaInsets.top = 0
        let sumInsets = customSafeAreaInsets + layoutStyles.contentInsets

        let editTaskItemsLayout = EditTaskItemsLayout(
                contentSize: scrollView.contentSize,
                stackViewHeight: layoutStyles.stackViewHeight,
                buttonHeight: layoutStyles.buttonHeight,
                textViewHeight: textView.bounds.height,
                datePickerHeight: !datePicker.isHidden ? layoutStyles.datePickerHeight : 0,
                itemsMargin: layoutStyles.itemsVerticalMargin,
                boundsMinX: scrollView.bounds.minX,
                boundsHeight: scrollView.bounds.size.height,
                contentInsetBottom: scrollView.contentInset.bottom
        )

        scrollView.contentInset = sumInsets
        scrollView.contentSize = CGSize(
                width: view.frame.width - sumInsets.left - sumInsets.right,
                height: editTaskItemsLayout.contentSizeHeight
        )

        textView.frame = CGRect(
                origin: .zero,
                size: CGSize(width: scrollView.contentSize.width, height: layoutStyles.textViewDefaultHeight)
        )
        setItemsLayout()
    }
}

fileprivate extension UIEdgeInsets {
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

extension EditTaskViewController.LayoutStyles {
    static let defaultStyle = Self.init(
            contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16),
            textSize: 17,
            itemsBorderRadius: AppStyles.borderRadius,
            itemsBackgroundColor: Color.backgroundPrimary,
            buttonHeight: 56,
            stackViewHeight: 112.5,
            lineLeftPadding: 16,
            lineRightPadding: -16,
            lineHeight: 0.5,
            labelLeftPadding: 16,
            segmentControlRightPadding: -12,
            segmentControlHeight: 36,
            segmentControlWidth: 150
    )
}
