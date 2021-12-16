import Foundation
import UIKit

class RootGraph {
    var rootViewController: UIViewController {
        return navigationController
    }
    private let navigationController: UINavigationController
    private(set) var taskListGraph: TaskListGraph

    init() {
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
        navigationController.navigationBar.prefersLargeTitles = true 
        aNavigationController = navigationController
    }
}
