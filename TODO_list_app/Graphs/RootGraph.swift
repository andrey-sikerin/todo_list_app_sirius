import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UINavigationController
    private(set) var taskListGraph: TaskListGraph

    init() {
        self.taskListGraph = TaskListGraph()
        self.rootViewController = UINavigationController(rootViewController: taskListGraph.viewController)

//        let editTaskViewController = EditTaskViewController(strings: EditTaskViewController.Strings(
//                leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
//                rightNavigationBarText: NSLocalizedString("Save", comment: ""),
//                titleNavigationBarText: NSLocalizedString("Task", comment: "")
//        ))
//        let navigationController = UINavigationController(rootViewController: editTaskViewController)
//        rootViewController = navigationController
    }
}
