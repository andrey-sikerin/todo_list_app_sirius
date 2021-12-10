import UIKit

class EditTaskViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let testView = UIView()

    private let strings: Strings

    public struct Strings {
        let leftNavigationBarText: String
        let rightNavigationBarText: String
        let titleNavigationBarText: String
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
        scrollView.contentInset = UIEdgeInsets(top: 16, left: view.safeAreaInsets.left + 16, bottom: view.safeAreaInsets.bottom + 32,
                right: view.safeAreaInsets.right + 16)
        scrollView.contentSize = CGSize(width: view.frame.width - 2*16 - view.safeAreaInsets.left -
                view.safeAreaInsets.right, height: 2*view.frame.height)
        testView.frame = CGRect(x:.zero, y:.zero, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        testView.backgroundColor = .blue

    }
}

