import UIKit

class EditTaskViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Edit task did load")

        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save")
        navigationItem.title = "Thing"

        label.textColor = .black
        label.text = "EditTaskController"
        label.textAlignment = .center
        view.addSubview(label)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        label.frame = CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: 200, height: 200)
        )

        label.center = view.center
    }

}

