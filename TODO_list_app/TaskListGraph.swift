//
//  TaskListGraph.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit

class TaskListGraph {
    private(set) var viewController: UIViewController
    
    init() {
        self.viewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: NSLocalizedString("Tasks", comment: "")
            )
        )
    }
}
