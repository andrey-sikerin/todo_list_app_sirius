import UIKit

class EditTaskViewController: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let textView = UITextView()
    private let stackView = UIStackView()
    private let button = UIButton()

    private let styles: Styles
    private let strings: Strings

    private var showPlaceholder = true
    private var keyboardHeight: CGFloat = 0

    public struct Strings {
        let leftNavigationBarText: String
        let rightNavigationBarText: String
        let titleNavigationBarText: String
        let textViewPlaceholder: String
        let buttonText: String
    }

    public struct Styles {
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        let itemsBorderRadius: CGFloat
        let itemsBackgroundColor: UIColor
        let itemsVerticalMargin: CGFloat = 16
        let backgroundColor: UIColor
        let textSize: CGFloat

        let textViewDefaultHeight: CGFloat = 120
        let textViewInnerPadding: CGFloat = 16
        let textViewTextColor: UIColor
        let textViewPlaceholderColor: UIColor

        let stackViewHeight: CGFloat = 113
        let buttonTextColor: UIColor
        let buttonPressedTextColor: UIColor
        let buttonHeight: CGFloat
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
        view.addGestureRecognizer(gestureRecognizer)
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

        // Text View
        let innerPadding = styles.textViewInnerPadding
        textView.textContainerInset = UIEdgeInsets(
                top: innerPadding, left: innerPadding, bottom: innerPadding, right: innerPadding
        )
        textView.text = strings.textViewPlaceholder
        textView.font = .systemFont(ofSize: styles.textSize)
        textView.layer.cornerRadius = styles.itemsBorderRadius
        textView.backgroundColor = styles.itemsBackgroundColor
        textView.textColor = styles.textViewPlaceholderColor
        textView.isScrollEnabled = false
        textView.delegate = self

        // Stack Views
        stackView.autoresizingMask = []
        stackView.layer.cornerRadius = styles.itemsBorderRadius
        stackView.backgroundColor = styles.itemsBackgroundColor

        // Button
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = styles.itemsBorderRadius
        button.backgroundColor = styles.itemsBackgroundColor
        button.setTitleColor(styles.buttonTextColor, for: .normal)
        button.setTitleColor(styles.buttonPressedTextColor, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: styles.textSize)
        button.setTitle(strings.buttonText, for: .normal)

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(textView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(button)
        view.addSubview(scrollView)

        NotificationCenter.default.addObserver(self,
                selector: #selector(onKeyboardOpened(keyboardShowNotification:)),
                name: UIResponder.keyboardDidShowNotification,
                object: nil)

        NotificationCenter.default.addObserver(self,
                selector: #selector(onKeyboardClosed(keyboardShowNotification:)),
                name: UIResponder.keyboardDidHideNotification,
                object: nil)
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
        print("Right button pressed")
    }

    @objc func onLeftBarButtonClicked() {
        print("Left button pressed")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin editing")
        textView.textColor = styles.textViewTextColor
        if (showPlaceholder) {
            textView.text = ""
            textView.textColor = styles.textViewTextColor
        }
    }


    private func changeTextViewSize(canStretchIndefinitely: Bool, withAnimation: Bool = false) {
        let textViewAvailableHeight = view.frame.height - scrollView.contentInset.bottom -
                scrollView.contentInset.top - keyboardHeight - 2 * styles.itemsVerticalMargin

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        let currentTextViewHeight = max(newSize.height, styles.textViewDefaultHeight)

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


    private func setItemsLayout() {
        stackView.frame = CGRect(
                origin: CGPoint(x: 0, y: textView.bounds.height + styles.itemsVerticalMargin),
                size: CGSize(width: scrollView.contentSize.width, height: styles.stackViewHeight)
        )

        let buttonOriginY = stackView.frame.maxY + styles.itemsVerticalMargin
        button.frame = CGRect(
                origin: CGPoint(x: 0, y: buttonOriginY),
                size: CGSize(width: scrollView.contentSize.width, height: styles.buttonHeight)
        )
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width,
                height: view.frame.height)
        var customSafeAreaInsets = view.safeAreaInsets
        customSafeAreaInsets.top = 0
        let sumInsets = customSafeAreaInsets + styles.contentInsets

        scrollView.contentInset = sumInsets
        scrollView.contentSize = CGSize(
                width: view.frame.width - sumInsets.left - sumInsets.right,
                height: 2 * view.frame.height
        )

        let itemsWidth = scrollView.contentSize.width

        textView.frame = CGRect(
                origin: .zero,
                size: CGSize(width: itemsWidth, height: styles.textViewDefaultHeight)
        )
        setItemsLayout()
    }
}

fileprivate extension UIEdgeInsets {
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

