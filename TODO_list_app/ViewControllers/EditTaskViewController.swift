import UIKit

class EditTaskViewController: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let textView = UITextView()

    private let styles: Styles
    private let strings: Strings

    private var showPlaceholder = true

    public struct Strings {
        let leftNavigationBarText: String
        let rightNavigationBarText: String
        let titleNavigationBarText: String
        let textViewPlaceholder: String
    }

    public struct Styles {
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        let borderRadius: CGFloat
        let itemsBackground: UIColor
        let backgroundColor: UIColor
        let textSize: CGFloat

        let textViewDefaultHeight: CGFloat = 120
        let textViewInnerPadding: CGFloat = 16
        let textViewTextColor: UIColor
        let textViewPlaceholderColor: UIColor
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
        textView.layer.cornerRadius = styles.borderRadius
        textView.backgroundColor = styles.itemsBackground
        textView.textColor = styles.textViewPlaceholderColor
        textView.isScrollEnabled = false
        textView.delegate = self

        scrollView.addSubview(textView)
        view.addSubview(scrollView)
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

    func textViewDidChange(_ textView: UITextView) {
        // Change textView height
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(
                width: max(newSize.width, fixedWidth),
                height: max(newSize.height, styles.textViewDefaultHeight)
        )
        textView.frame = newFrame
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

        textView.frame = CGRect(
                origin: .zero,
                size: CGSize(width: scrollView.contentSize.width, height: styles.textViewDefaultHeight)
        )
    }
}

fileprivate extension UIEdgeInsets {
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

