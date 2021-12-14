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
                        borderRadius: AppStyles.borderRadius,
                        itemsBackground: Color.backgroundSecondary,
                        backgroundColor: Color.backgroundPrimary,
                        textSize: 17,
                        textViewTextColor: Color.labelPrimary,
                        textViewPlaceholderColor: Color.labelTertiary
                )
        )
        let navigationController = UINavigationController(rootViewController: editTaskViewController)
        rootViewController = navigationController
        */
        self.taskListGraph = TaskListGraph()
        self.rootViewController = UINavigationController(rootViewController: taskListGraph.viewController)
    }
}
