import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UINavigationController
    private(set) var taskListGraph: TaskListGraph
    
    init() {
        let taskListController = TaskListViewController()
        self.rootViewController = UINavigationController(rootViewController)
        self.taskListGraph = TaskListGraph(with: taskListController)
        
       // let editTaskViewController = EditTaskViewController(strings: EditTaskViewController.Strings(
         //   leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
            //   rightNavigationBarText: NSLocalizedString("Save", comment: ""),
         //   titleNavigationBarText: NSLocalizedString("Task", comment: "")
       // ))
    }
}
