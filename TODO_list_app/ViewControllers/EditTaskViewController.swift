import UIKit

class EditTaskViewController: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let textView = UITextView()
    private let stackView = UIStackView()
    private let button = UIButton()
    private let datePicker = UIDatePicker()
    private let labelsStack = UIStackView()
    private let primaryLabel = UILabel()
    private let secondaryLabel = UILabel()
    private let switcher = UISwitch()
    private let line = UIView()
    private let line2 = UIView()
    private let deadLineStackView = UIStackView()
    private let priorityStackView = UIStackView()

    private let styles: Styles
    private let layoutStyles: LayoutStyles = .defaultStyle
    private let strings: Strings

    private var showingDatePicker = false {
        didSet {
            datePicker.isHidden = !showingDatePicker
        }
    }

    private var selectedDate: Date? {
        didSet {
            secondaryLabel.text = selectedDateString
        }
    }
    private var selectedDateString: String {
        if let date = selectedDate {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .none
        return formatter
    }()

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

    fileprivate struct LayoutStyles {
        let contentInsets: UIEdgeInsets
        let textSize: CGFloat

        let textViewDefaultHeight: CGFloat = 120
        let textViewInnerPadding: CGFloat = 16

        let itemsBorderRadius: CGFloat
        let itemsBackgroundColor: UIColor
        let itemsVerticalMargin: CGFloat = 16
        let stackViewHeight: CGFloat = 113
        let buttonHeight: CGFloat

        let lineLeftPadding : CGFloat = 16
        let lineRightPadding : CGFloat = -16
        let lineHeight: CGFloat = 0.5
        let lineOpacity: CGFloat = 0.2

        let labelsLeadingOffset: CGFloat = 16
        let switcherTrailingOffset: CGFloat = 12
        let primaryLabelFontSize: CGFloat = 17
        let secondaryLabelFontSize: CGFloat = 13
        let datePickerHeight: CGFloat = 340
    }

    public struct Styles {
        var itemsBackground: UIColor
        var backgroundColor: UIColor
        var textViewTextColor: UIColor
        var textViewPlaceholderColor: UIColor
        let buttonTextColor: UIColor
        let buttonPressedTextColor: UIColor
    }

    init(strings: Strings, styles: Styles) {
        self.strings = strings
        self.styles = styles
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTouchScreen))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer) // not working with this
        view.backgroundColor = styles.backgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: strings.leftNavigationBarText,
                style: .plain,
                target: self,
                action: #selector(onLeftBarButtonClicked)
        )
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
        textView.text = strings.textViewPlaceholder
        textView.font = .systemFont(ofSize: layoutStyles.textSize)
        textView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        textView.backgroundColor = styles.itemsBackground
        textView.textColor = styles.textViewPlaceholderColor
        textView.isScrollEnabled = false
        textView.delegate = self

        let smallStackViewHeight: CGFloat = (layoutStyles.stackViewHeight - layoutStyles.lineHeight) / 2

        // Set datePicker
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.calendar = .autoupdatingCurrent
        datePicker.isHidden = !showingDatePicker
        datePicker.addTarget(self, action: #selector(datePicked), for: .allEvents)

        // Set primaryLabel
        primaryLabel.text = strings.doBeforeText
        primaryLabel.font = .systemFont(ofSize: layoutStyles.primaryLabelFontSize)

        // Set secondaryLabel
        secondaryLabel.text = selectedDateString
        secondaryLabel.font = .boldSystemFont(ofSize: layoutStyles.secondaryLabelFontSize)
        secondaryLabel.textColor = .systemBlue

        // Set labelsStack
        labelsStack.axis = .vertical
        labelsStack.alignment = .leading
        labelsStack.spacing = 0
        labelsStack.distribution = .fillProportionally
        labelsStack.addArrangedSubview(primaryLabel)
        labelsStack.addArrangedSubview(secondaryLabel)

        // Set switcher
        switcher.isOn = showingDatePicker
        switcher.preferredStyle = .sliding
        switcher.addTarget(self, action: #selector(switcherTapped), for: .allTouchEvents)

        // Set deadLineStackView
        deadLineStackView.axis = .horizontal
        deadLineStackView.distribution = .fill
        deadLineStackView.alignment = .center
        deadLineStackView.addArrangedSubview(labelsStack)
        deadLineStackView.addArrangedSubview(switcher)


        stackView.autoresizingMask = []
        stackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        // calculates height of smallStackViews
        

        // Set deadLineStackView
        deadLineStackView.axis = .horizontal
        deadLineStackView.distribution = .fill
        deadLineStackView.alignment = .center
        deadLineStackView.addArrangedSubview(labelsStack)
        deadLineStackView.addArrangedSubview(switcher)

        // Stack View
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        stackView.backgroundColor = styles.itemsBackground
        stackView.addArrangedSubview(priorityStackView)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(deadLineStackView)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(line2)

        // Button
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = layoutStyles.itemsBorderRadius
        button.backgroundColor = styles.itemsBackground
        button.setTitleColor(styles.buttonTextColor, for: .normal)
        button.setTitleColor(styles.buttonPressedTextColor, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: layoutStyles.textSize)
        button.setTitle(strings.buttonText, for: .normal)

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(textView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(button)
        view.addSubview(scrollView)

        // Setup elements
        setPriorityStackView(smallStackViewHeight)
        setDeadLineStackView(smallStackViewHeight)
        setLine(line)
        setLine(line2)


        NotificationCenter.default.addObserver(self,
                selector: #selector(onKeyboardOpened(keyboardShowNotification:)),
                name: UIResponder.keyboardDidShowNotification,
                object: nil)

        NotificationCenter.default.addObserver(self,
                selector: #selector(onKeyboardClosed(keyboardShowNotification:)),
                name: UIResponder.keyboardDidHideNotification,
                object: nil)
    }

    @objc func datePicked(sender: UIDatePicker) {
        selectedDate = datePicker.date
    }

    @objc func switcherTapped(sender: UISwitch) {
        showingDatePicker = sender.isOn
        if showingDatePicker {
            selectedDate = datePicker.date
        } else {
            selectedDate = nil
        }
        setItemsLayout()
    }

    @objc func onKeyboardOpened(keyboardShowNotification notification: Notification) {
        print("Keyboard opened")
        changeTextViewSize(canStretchIndefinitely: false, withAnimation: true)

        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardRectangle.height
        }
    }

    @objc func onButtonPress() {
        print("Button pressed")
    }

    @objc func onKeyboardClosed(keyboardShowNotification notification: Notification) {
        print("Keyboard closed")
        changeTextViewSize(canStretchIndefinitely: true, withAnimation: true)
        setItemsLayout()
    }

    @objc func onTouchScreen(_ sender: UITapGestureRecognizer) {
        print("Screen touched")
        textView.resignFirstResponder()
    }

    @objc func onRightBarButtonClicked() {
        textView.resignFirstResponder()
    }

    @objc func onLeftBarButtonClicked() {
        print("Left button pressed")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = styles.textViewTextColor
        if (showPlaceholder) {
            textView.text = ""
            textView.textColor = styles.textViewTextColor
        }
    }


    private func setPriorityStackView(_ smallStackViewHeight : CGFloat){
        priorityStackView.backgroundColor = .brown
        priorityStackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        priorityStackView.heightAnchor.constraint(equalToConstant: smallStackViewHeight).isActive = true
        priorityStackView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0).isActive = true
        priorityStackView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0).isActive = true
    }

    private func setDeadLineStackView(_ smallStackViewHeight : CGFloat) {
        deadLineStackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        deadLineStackView.heightAnchor.constraint(equalToConstant: smallStackViewHeight).isActive = true
        deadLineStackView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: layoutStyles.labelsLeadingOffset).isActive = true
        deadLineStackView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -layoutStyles.switcherTrailingOffset).isActive = true
    }

    private func setLine(_ line: UIView) {
        line.backgroundColor = UIColor.black.withAlphaComponent(layoutStyles.lineOpacity)
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
            print("Text view doesn't have enough space, start scrolling")
            height = textViewAvailableHeight
            textView.isScrollEnabled = true
        } else {
            print("Text view has enough space, extends")
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
        print("End editing")
        if textView.text.isEmpty {
            showPlaceholder = true
            textView.text = strings.textViewPlaceholder
            textView.textColor = styles.textViewPlaceholderColor
        } else {
            showPlaceholder = false
        }
    }

//    private func setItemsLayout() {
//        stackView.frame = CGRect(
//                origin: CGPoint(x: 0, y: textView.bounds.height + layoutStyles.itemsVerticalMargin),
//                size: CGSize(width: scrollView.contentSize.width, height: layoutStyles.stackViewHeight)
//    }
    private func setItemsLayout() {
        let stackViewHeight = layoutStyles.stackViewHeight + (showingDatePicker ? layoutStyles.datePickerHeight : 0)
        stackView.frame = CGRect (
                origin: CGPoint(x: 0, y: textView.bounds.height + layoutStyles.itemsVerticalMargin),
                size: CGSize(width: scrollView.contentSize.width, height: stackViewHeight)
        )

        let buttonOriginY = stackView.frame.maxY + layoutStyles.itemsVerticalMargin
        button.frame = CGRect(
                origin: CGPoint(x: 0, y: buttonOriginY),
                size: CGSize(width: scrollView.contentSize.width, height: layoutStyles.buttonHeight)
        )
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width,
                height: view.frame.height)
        var customSafeAreaInsets = view.safeAreaInsets
        customSafeAreaInsets.top = 0
        let sumInsets = customSafeAreaInsets + layoutStyles.contentInsets

        scrollView.contentInset = sumInsets
        scrollView.contentSize = CGSize(
                width: view.frame.width - sumInsets.left - sumInsets.right,
                height: 2 * view.frame.height
        )

        let itemsWidth = scrollView.contentSize.width

        textView.frame = CGRect(
                origin: .zero,
                size: CGSize(width: itemsWidth, height: layoutStyles.textViewDefaultHeight)
        )
        setItemsLayout()
    }
}

fileprivate extension UIEdgeInsets {
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

fileprivate extension EditTaskViewController.LayoutStyles {
    static let defaultStyle = Self.init(
      contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16),
      textSize: 17,
      itemsBorderRadius: AppStyles.borderRadius,
      itemsBackgroundColor: Color.backgroundPrimary,
      buttonHeight: 56
    )
}
