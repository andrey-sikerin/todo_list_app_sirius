//
//  RootGraph.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 09.12.2021.
//

import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UINavigationController
    private(set) var taskListGraph: TaskListGraph
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        let taskListController = TaskListViewController()
        rootViewController.viewControllers = [taskListController]
        self.taskListGraph = TaskListGraph(with: taskListController)
    }
}
