import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UINavigationController
    private(set) var taskListGraph: TaskListGraph

    init() {
        /*
        let editTaskViewController = EditTaskViewController(
                strings: EditTaskViewController.Strings(
                        leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
                        rightNavigationBarText: NSLocalizedString("Save", comment: ""),
                        titleNavigationBarText: NSLocalizedString("Task", comment: ""),
                        textViewPlaceholder: NSLocalizedString("TaskDescriptionPlaceholder", comment: "")
                ),
                styles: EditTaskViewController.Styles(
                        itemsBackground: .white,
                        backgroundColor: .lightGray,
                        textViewTextColor: .black,
                        textViewPlaceholderColor: .gray
                )
        )
        rootViewController = UINavigationController(rootViewController: editTaskViewController)
        */
        self.taskListGraph = TaskListGraph()
        self.rootViewController = UINavigationController(rootViewController: taskListGraph.viewController)
    }
}
