import UIKit

class EditTaskViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let layoutStyle: LayoutStyle = .defaultStyle
    private let testView = UIView()
    private let strings: Strings

    public struct Strings {
        let leftNavigationBarText: String
        let rightNavigationBarText: String
        let titleNavigationBarText: String
    }

    fileprivate struct LayoutStyle {
        let contentInsets: UIEdgeInsets
    }

    init(strings: Strings) {
        self.strings = strings
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        testView.backgroundColor = .blue
        view.addSubview(scrollView)
        scrollView.addSubview(testView)
    }

    @objc func onRightBarButtonClicked() {
        print("Right button pressed")
    }

    @objc func onLeftBarButtonClicked() {
        print("Left button pressed")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width,
                height: view.frame.height)
        var customSafeAreaInsets = view.safeAreaInsets
        customSafeAreaInsets.top = 0
        let sumInsets = customSafeAreaInsets + layoutStyle.contentInsets

        scrollView.contentInset = sumInsets
        scrollView.contentSize = CGSize(
                width: view.frame.width - sumInsets.left - sumInsets.right,
                height: 2 * view.frame.height
        )
        testView.frame = CGRect(x: .zero, y: .zero, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
}

fileprivate extension UIEdgeInsets{
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

fileprivate extension EditTaskViewController.LayoutStyle {
    static let defaultStyle = Self.init(contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16))
}

