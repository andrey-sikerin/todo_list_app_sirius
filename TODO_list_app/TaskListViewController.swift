//
//  TaskListViewController.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    
    private static let numberOfRows = 20

    private lazy var taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Tasks"
        taskTableView.delegate = self
        taskTableView.dataSource = self
        view.addSubview(taskTableView)
        taskTableView.frame = view.bounds
        taskTableView.rowHeight = 56
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TaskListViewController.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as? ToDoCell else { return UITableViewCell() }
        
        if indexPath.row == TaskListViewController.numberOfRows - 1 {
            let newTaskCell = AddNewTaskCell()
            newTaskCell.configure()
            return newTaskCell
        }

        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Header"
    }


}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct InfoVCPreview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        TaskListViewController().toPreview()
    }
}
#endif
