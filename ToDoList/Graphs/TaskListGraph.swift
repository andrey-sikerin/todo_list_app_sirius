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
    private var tasks: FileCache = FileCache.test
    private var currentEdit: EditTaskGraph?
    private var rootRouter: RootRouter

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
                    buttonText: NSLocalizedString("Delete", comment: "")
                ),
                styles: EditTaskViewController.Styles(
                    itemsBackground: Color.backgroundSecondary,
                    backgroundColor: Color.backgroundPrimary,
                    textViewTextColor: Color.labelPrimary,
                    textViewPlaceholderColor: Color.labelTertiary,
                    buttonTextColor: .black,
                    buttonPressedTextColor: .black
                ),
                transitionToTaskList: transitionToTaskListVC
            )

            switch mode {
            case .push: rootRouter.pushAction(editTaskVC)
            case .present: rootRouter.presentAction(UINavigationController(rootViewController: editTaskVC))
            }

        }

        self.viewController = TaskListViewController(
            strings: TaskListViewController.Strings (
                titleNavigationBarText: NSLocalizedString("Tasks", comment: ""),
                doneAmountLabelText: NSLocalizedString("Completed", comment: ""),
                showDoneButtonText: NSLocalizedString("Show", comment: ""),
                hideDoneButtonText: NSLocalizedString("Hide", comment: "")
            ),
            transitionToEdit: transitionToEditVC)
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
        let buyFood = TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low)
        let goRun = TodoItem(text: "Running is good", priority: .normal)
        let homework = TodoItem(text: "Copy It", deadline: Date().addingTimeInterval(3600), priority: .high)
        let cookLunch = TodoItem(text: "Cook yourself!", priority: .normal)
        let eatLunch = TodoItem(text: "Enjoy", priority: .normal)
        let goSleep = TodoItem(text: "Sleeping is essential", deadline: Date().addingTimeInterval(3600 * 5), priority: .high)
        file.addTask(buyFood)
        file.addTask(goRun)
        file.addTask(homework)
        file.addTask(cookLunch)
        file.addTask(eatLunch)
        file.addTask(goSleep)
        return file
    }()
}
