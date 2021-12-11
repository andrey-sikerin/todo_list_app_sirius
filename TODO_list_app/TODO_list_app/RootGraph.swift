import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UIViewController

    init() {
        let editTaskViewController = EditTaskViewController(strings: EditTaskViewController.Strings(
                leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
                rightNavigationBarText: NSLocalizedString("Save", comment: ""),
                titleNavigationBarText: NSLocalizedString("Task", comment: "")
        ))
        let navigationController = UINavigationController(rootViewController: editTaskViewController)
        rootViewController = navigationController
    }
}
