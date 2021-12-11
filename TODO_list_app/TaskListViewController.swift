//
//  TaskListViewController.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    struct Strings {
        let titleNavigationBarText: String
    }
    
    private let strings: Strings
    
    init(strings: Strings) {
        self.strings = strings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
