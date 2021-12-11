//
//  TaskListViewController.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    
    private var taskTableView = UITableView(frame: .zero, style: .insetGrouped)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(taskTableView)
        setUpTableView()
    }
    
    func setUpTableView() {
        view.addSubview(taskTableView)
        
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        taskTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        taskTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test")!
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "TasksList"
    }
}
