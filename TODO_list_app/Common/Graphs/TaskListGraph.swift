//
//  TaskListGraph.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit
import RxSwift

class TaskListGraph {
    private(set) var viewController: UIViewController
    private var currentEdit: EditTaskGraph?
    public var rootRouter: RootRouter
    private let cacheFilename = "brawl_stars.txt"
    private let todoItemsBehaviorSubject: BehaviorSubject<[TodoItem]>

    init(rootRouter: RootRouter) {
        let todoItemsBehaviorSubject = BehaviorSubject<[TodoItem]>(value: [])
        self.rootRouter = rootRouter
        self.todoItemsBehaviorSubject = todoItemsBehaviorSubject

        let editAction: TransitionAction = { mode, vc, item in
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
                viewModel: EditTaskViewModel(
                    item: item,
                    transitionToTaskList: transitionToTaskListVC
                ),
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
                    showingCancelButton: mode == .push ? false : true)
            )

            switch mode {
            case .push: rootRouter.pushAction(editTaskVC)
            case .present: rootRouter.presentAction(UINavigationController(rootViewController: editTaskVC))
            }

        }

        let deleteAction: DeleteAction = { id in
            var value = try! todoItemsBehaviorSubject.value()
            value.removeAll(where: { $0.id == id })

            todoItemsBehaviorSubject.on(.next(value))
        }

        let fileCache = FileCache(
            manager: FileCache.FileManager(write: { data, url in
                try data.write(to: url)
            }, read: { url in
                    return try Data(contentsOf: url)
                })
        )

        todoItemsBehaviorSubject.on(.next(FileCache.test.todoItems))

        let todoListSubscription = try? QueryService.getTodoList()
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
                todoItemsBehaviorSubject.on(.next(todoItemsArray))
            case .failure(let error):
                print("Error: ", error)
            }
        }
        let modeSubject: BehaviorSubject<HeaderViewModel.Mode> = .init(value: .show)
        //        let viewModelsObservable = todoItemsBehaviorSubject.map { items in
        //          items.map { ToDoCellViewModel(todoItem: $0, editAction: editAction) }
        //        }



        let viewModelsObservable: Observable<[ToDoCellViewModel]> =
            Observable.combineLatest(todoItemsBehaviorSubject, modeSubject).map { (items: [TodoItem], mode: HeaderViewModel.Mode) in
            var resultedItems: [TodoItem]
            switch mode {
            case .show:
                resultedItems = items
            case .hide:
                resultedItems = items.filter { !$0.done }
            }

            return resultedItems.map {
                ToDoCellViewModel(
                    todoItem: $0,
                    editAction: editAction,
                    deleteAction: deleteAction
                )
            }
        }

        fileCache.load(from: cacheFilePath!)
        viewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: NSLocalizedString("Tasks", comment: "")
            ),
            todoItemViewModelsObservale: viewModelsObservable,
            headerViewModel: HeaderViewModel(
                todoItemsObservable: todoItemsBehaviorSubject,
                strings: HeaderViewModel.Strings(
                    doneText: NSLocalizedString("Completed", comment: ""),
                    hideText: NSLocalizedString("Show", comment: ""),
                    showText: NSLocalizedString("Hide", comment: "")
                ),
                modeSubject: modeSubject
            ),
            makeNewItemAction: { editAction(.present, $0, .emptyItem) }
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
