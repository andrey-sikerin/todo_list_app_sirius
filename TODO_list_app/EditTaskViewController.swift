import UIKit

class EditTaskViewController: UIViewController {
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
    }

    @objc func onRightBarButtonClicked() {
        print("Right button pressed")
    }

    @objc func onLeftBarButtonClicked() {
        print("Left button pressed")
    }
}

