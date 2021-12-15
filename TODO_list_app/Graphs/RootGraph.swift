import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UINavigationController
    private(set) var taskListGraph: TaskListGraph

    init() {
//        let editTaskViewController = EditTaskViewController(
//                notificationCenter: NotificationCenter.default,
//                strings: EditTaskViewController.Strings(
//                        leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
//                        rightNavigationBarText: NSLocalizedString("Save", comment: ""),
//                        titleNavigationBarText: NSLocalizedString("Task", comment: ""),
//                        textViewPlaceholder: NSLocalizedString("TaskDescriptionPlaceholder", comment: ""),
//                        buttonText: NSLocalizedString("Delete", comment: "")
//                ),
//                styles: EditTaskViewController.Styles(
//                        itemsBackground: Color.backgroundSecondary,
//                        backgroundColor: Color.backgroundPrimary,
//                        textViewTextColor: Color.labelPrimary,
//                        textViewPlaceholderColor: Color.labelSecondary,
//                        buttonTextColor: Color.labelTertiary,
//                        buttonPressedTextColor: .black
//                )
//        )
//        rootViewController = UINavigationController(rootViewController: editTaskViewController)

        self.taskListGraph = TaskListGraph()
        self.rootViewController = UINavigationController(rootViewController: taskListGraph.viewController)
    }
}
