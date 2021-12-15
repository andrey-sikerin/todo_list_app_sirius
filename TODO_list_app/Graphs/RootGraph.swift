import Foundation
import UIKit

class RootGraph {
    var rootViewController: UIViewController {
        return navigationController
    }
    private let navigationController: UINavigationController
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
        var aNavigationController: UINavigationController?

        taskListGraph = TaskListGraph(
            rootRouter: RootRouter(
                pushAction: {
                    aNavigationController?.pushViewController($0, animated: true)
                },
                popAction: {
                    aNavigationController?.popViewController(animated: true)
                },
                presentAction: {
                    aNavigationController?.present($0, animated: true, completion: nil)
                },
                dismissAction: {
                    $0.dismiss(animated: true, completion: nil)
                }

            )
        )
        navigationController = UINavigationController(
            rootViewController: taskListGraph.viewController)
        aNavigationController = navigationController
    }
}
