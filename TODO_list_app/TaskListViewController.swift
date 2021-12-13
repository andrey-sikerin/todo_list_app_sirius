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
    
    private struct SwipeIcons {
        static let doneIconName = "doneIcon"
        static let doneIconPosition = CGPoint(x: 20, y: 20)
        static let doneIconSize = CGSize(width: 27, height: 26)
        static let doneContainerSize = CGSize(width: 67, height: 66)
        static let doneIconColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
        
        static let infoIconName = "infoIcon"
        static let infoIconPosition = CGPoint(x: 20, y: 20)
        static let infoIconSize = CGSize(width: 27, height: 26)
        static let infoContainerSize = CGSize(width: 67, height: 66)
        static let infoIconColor = UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1)
        
        static let deleteIconName = "deleteIcon"
        static let deleteIconPosition = CGPoint(x: 20, y: 20)
        static let deleteIconSize = CGSize(width: 26, height: 26)
        static let deleteContainerSize = CGSize(width: 66, height: 66)
        static let deleteIconColor = UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1)
    }

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
    
    private func handleMarkAsDone(at indexPath: IndexPath) {
        print("task is done")
    }
    
    private func handleInfoTask(at indexPath: IndexPath) {
        print("task is redacting")
    }
    
    private func handleDeleteTask(at indexPath: IndexPath) {
        print("task deleted")
    }
    
    private func isLastRow(_ indexPath: IndexPath) -> Bool {
        indexPath.row == TaskListViewController.numberOfRows - 1
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TaskListViewController.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as? ToDoCell else { return UITableViewCell() }
        
        if isLastRow(indexPath) {
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !isLastRow(indexPath) else {
            return nil
        }
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completion) in
            self.handleMarkAsDone(at: indexPath)
            completion(true)
        }
        doneAction.image = UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: SwipeIcons.doneContainerSize)).image { _ in
            UIImage(named: SwipeIcons.doneIconName)?.draw(in: CGRect(origin: SwipeIcons.doneIconPosition, size: SwipeIcons.doneIconSize))
        }
        doneAction.backgroundColor = SwipeIcons.doneIconColor
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !isLastRow(indexPath) else {
            return nil
        }
        
        let infoAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completion) in
            self.handleInfoTask(at: indexPath)
            completion(true)
        }
        infoAction.image = UIGraphicsImageRenderer(size: SwipeIcons.infoContainerSize).image { _ in
            UIImage(named: SwipeIcons.infoIconName)?.draw(in: CGRect(origin: SwipeIcons.infoIconPosition, size: SwipeIcons.infoIconSize))
        }
        infoAction.backgroundColor = SwipeIcons.infoIconColor
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completion) in
            self.handleDeleteTask(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIGraphicsImageRenderer(size: SwipeIcons.doneContainerSize).image { _ in
            UIImage(named: SwipeIcons.deleteIconName)?.draw(in: CGRect(origin: SwipeIcons.deleteIconPosition, size: SwipeIcons.deleteIconSize))
        }
        deleteAction.backgroundColor = SwipeIcons.deleteIconColor
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
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
