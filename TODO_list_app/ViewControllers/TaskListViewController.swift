//
//  TaskListViewController.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit
import RxSwift

class TaskListViewController: UIViewController {
    public static let numberOfRows = 3
    private var todoItems: [TodoItem] = []

    private struct SwipeIcons {
        static let doneIconName = "doneIcon"
        static let doneIconPosition = CGPoint(x: 20, y: 20)
        static let doneIconSize = CGSize(width: 27, height: 26)
        static let doneContainerSize = CGSize(width: 67, height: 66)
        static let doneIconColor = Color.green

        static let infoIconName = "infoIcon"
        static let infoIconPosition = CGPoint(x: 20, y: 20)
        static let infoIconSize = CGSize(width: 27, height: 26)
        static let infoContainerSize = CGSize(width: 67, height: 66)
        static let infoIconColor = Color.lightGray

        static let deleteIconName = "deleteIcon"
        static let deleteIconPosition = CGPoint(x: 20, y: 20)
        static let deleteIconSize = CGSize(width: 26, height: 26)
        static let deleteContainerSize = CGSize(width: 66, height: 66)
        static let deleteIconColor = Color.red
    }

    private struct PlusButton {
        static let dimension: CGFloat = 54
        static let size = CGSize(width: dimension, height: dimension)
        static let bottomOffset: CGFloat = 56
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: Float = 0.1
        private static let shadowOffsetX: CGFloat = 0
        private static let shadowOffsetY: CGFloat = 14
        static let shadowOffsetSize = CGSize(width: shadowOffsetX, height: shadowOffsetY)
    }

    struct Strings {
        let titleNavigationBarText: String
        let doneAmountLabelText: String
        let showDoneButtonText: String
        let hideDoneButtonText: String
    }

    private let strings: Strings

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(AddNewTaskCell.self, forCellReuseIdentifier: AddNewTaskCell.defaultReuseIdentifier)
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        return tableView
    }()

    typealias TransitionAction = (TransitionMode, UIViewController) -> Void
    private var transitionAction: TransitionAction

    init(strings: Strings, transitionToEdit: @escaping TransitionAction, todoItems: [TodoItem]) {
        self.strings = strings
        self.transitionAction = transitionToEdit
        self.todoItems = todoItems
        super.init(nibName: nil, bundle: nil)
    }

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "plusButton"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = PlusButton.shadowRadius
        button.layer.shadowOpacity = PlusButton.shadowOpacity
        button.layer.shadowOffset = PlusButton.shadowOffsetSize
        button.addTarget(self, action: #selector(plusButtonTriggered), for: .touchUpInside)
        return button
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        taskTableView.frame = view.bounds
        plusButton.frame = CGRect(
                origin: CGPoint(x: view.bounds.midX - PlusButton.dimension / 2,
                        y: view.bounds.maxY - (PlusButton.bottomOffset + PlusButton.dimension)),
                size: PlusButton.size)

        taskTableView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.largeTitleDisplayMode = .always
        title = strings.titleNavigationBarText
        setUpTableView()
        view.addSubview(plusButton)
    }

    func setUpTableView() {
        taskTableView.autoresizingMask = []
        taskTableView.delegate = self
        taskTableView.dataSource = self
        view.addSubview(taskTableView)
        taskTableView.frame = view.bounds
        taskTableView.rowHeight = 56

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        taskTableView.reloadData()
    }

    @objc func plusButtonTriggered(sender: Any) {
        transitionAction(.present, self)
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
        indexPath.row == todoItems.count
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        defaultHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLastRow(indexPath) {
            guard let newTaskCell = tableView.dequeueReusableCell(withIdentifier: AddNewTaskCell.defaultReuseIdentifier) as? AddNewTaskCell else {
                print("Unable to dequeue a cell with Identifier: \(reuseIdentifier)")
                return UITableViewCell()
            }
            newTaskCell.backgroundColor = Color.backgroundSecondary
            return newTaskCell
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier) as? ToDoCell else {
                print("Unable to dequeue a cell with Identifier: \(reuseIdentifier)")
                return UITableViewCell()
            }
            let currentItem = todoItems[indexPath.row];
            cell.backgroundColor = Color.backgroundSecondary
            cell.configureCell(todoItem: currentItem)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)

            return cell
        }
    }
}

extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = HeaderView()
        headerView.configureHeader(
                doneAmount: 5,
                labelText: strings.doneAmountLabelText,
                showDoneButtonText: strings.showDoneButtonText,
                hideDoneButtonText: strings.hideDoneButtonText)

        return headerView
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row number: \(indexPath.row)")
        if isLastRow(indexPath) {
            transitionAction(.present, self)
        } else {
            transitionAction(.push, self)
        }
    }
}

fileprivate let reuseIdentifier = "test"
fileprivate let numberOfRows = 20
fileprivate let defaultHeight: CGFloat = 56

