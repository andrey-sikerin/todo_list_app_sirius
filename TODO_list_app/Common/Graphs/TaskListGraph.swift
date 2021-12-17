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
    private var currentEdit: EditTaskGraph?
    public var rootRouter: RootRouter
    private let cacheFilename = "brawl_stars.txt"

    init(rootRouter: RootRouter) {
        self.rootRouter = rootRouter
        let transitionToEditVC: (TransitionMode, UIViewController) -> Void = { mode, vc in

            let transitionToTaskListVC: PopAction
            switch mode {
            case .push: transitionToTaskListVC = {
                    rootRouter.popAction()
                }
            case .present: transitionToTaskListVC = {
                    rootRouter.dismissAction(vc)
                }
            }

            let editTaskVC = EditTaskViewController(
                notificationCenter: .default,
                strings: EditTaskViewController.Strings(
                    leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
                    rightNavigationBarText: NSLocalizedString("Save", comment: ""),
                    titleNavigationBarText: NSLocalizedString("Task", comment: ""),
                    textViewPlaceholder: NSLocalizedString("TaskDescriptionPlaceholder", comment: ""),
                    buttonText: NSLocalizedString("Delete", comment: ""),
                            doBeforeText: NSLocalizedString("Make up", comment: "")),
                styles: EditTaskViewController.Styles(
                    itemsBackground: Color.backgroundSecondary,
                    backgroundColor: Color.backgroundPrimary,
                    textViewTextColor: Color.labelPrimary,
                    textViewPlaceholderColor: Color.labelTertiary,
                    buttonTextColor: Color.labelTertiary,
                    buttonPressedTextColor: Color.labelPrimary,
                    showingCancelButton: mode == .push ? false : true),
                transitionToTaskList: transitionToTaskListVC
            )

            switch mode {
            case .push: rootRouter.pushAction(editTaskVC)
            case .present: rootRouter.presentAction(UINavigationController(rootViewController: editTaskVC))
            }

        }

        let fileCache = FileCache(
                manager: FileCache.FileManager(write: { data, url in
                    try data.write(to: url)
                }, read: { url in
                    return try Data(contentsOf: url)
                })
        )

        let todoListSubscription = try? QueryService.getTodoList()
        let todoListViewModelsSubscription = todoListSubscription?.map { items in
            items.map { ToDoCellViewModel(todoItem: $0) }
        }
        let cacheFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent(cacheFilename)

        let _ = todoListSubscription?.subscribe { event in
            switch event {
            case .success(let todoItemsArray):
                // Write all items in cache, duplicates will be merged automatically
                todoItemsArray.forEach { item in
                    fileCache.addTask(item)
                }
                fileCache.save(to: cacheFilePath!)
            case .failure(let error):
                print("Error: ", error)
            }
        }

        fileCache.load(from: cacheFilePath!)

        viewController = TaskListViewController(
                strings: TaskListViewController.Strings(
                        titleNavigationBarText: NSLocalizedString("Tasks", comment: ""),
                        doneAmountLabelText: NSLocalizedString("Completed", comment: ""),
                        showDoneButtonText: NSLocalizedString("Show", comment: ""),
                        hideDoneButtonText: NSLocalizedString("Hide", comment: "")
                ),
                transitionToEdit: transitionToEditVC,
                todoItemViewModels: FileCache.test.todoItems.map { .init(todoItem: $0) },
                todoItemsSubscription: todoListViewModelsSubscription
        )
    }
}

fileprivate extension FileCache {
    static var test: FileCache = {
        let manager = FileCache.FileManager(write: { data, url in
            try data.write(to: url)
        }, read: { url in
                try Data(contentsOf: url)
            })
        let file = FileCache(manager: manager)
        let buyFood = TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low, done: true)
        let goRun = TodoItem(text: "Running is good", priority: .normal, done: true)
        let homework = TodoItem(text: "Copy It", deadline: Date().addingTimeInterval(3600), priority: .high, done: false)
        let cookLunch = TodoItem(text: "Cook yourself!", priority: .normal, done: true)
        let eatLunch = TodoItem(text: "Enjoy", priority: .normal, done: false)
        let goSleep = TodoItem(text: "Sleeping is essential", deadline: Date().addingTimeInterval(3600 * 5), priority: .high, done: false)
        file.addTask(buyFood)
        file.addTask(goRun)
        file.addTask(homework)
        file.addTask(cookLunch)
        file.addTask(eatLunch)
        file.addTask(goSleep)
        return file
    }()
}
