//
//  EditTaskGraph.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 14.12.2021.
//

import Foundation

class EditTaskGraph {
    private(set) var viewController: EditTaskViewController
    private var todoItem: TodoItem
    
    init(viewController: EditTaskViewController, item: TodoItem) {
        self.viewController = viewController
        self.todoItem = item
    }
}
