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
    public var rootRouter: RootRouter
    private let cacheFilename = "brawl_stars.txt"
    private var todoItemsBehaviorSubject: BehaviorSubject<[TodoItem]>
    private let disposeBag = DisposeBag()
    
    
    init(rootRouter: RootRouter) {
        let todoItemsBehaviorSubject = BehaviorSubject<[TodoItem]>(value: [])
        self.rootRouter = rootRouter
        let queryService = QueryService(
            baseUrl: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/",
            token: "zmkyqsxknnjiuftazbqthmnbagguxtvr" // TODO init from secret storage
        )


        self.todoItemsBehaviorSubject = todoItemsBehaviorSubject

        let updateAction: UpdateAction = { item in
            var value = try! todoItemsBehaviorSubject.value()
            if let index = value.firstIndex(where: {$0.id == item.id}) {
                value[index] = item
            } else {
                value.append(item)
            }
            todoItemsBehaviorSubject.on(.next(value))
        }

        let deleteAction: DeleteAction = { id in
            var value = try! todoItemsBehaviorSubject.value()
            value.removeAll(where: { $0.id == id })

            todoItemsBehaviorSubject.on(.next(value))
        }
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
                    transitionToTaskList: transitionToTaskListVC,
                    deleteAction: deleteAction,
                    updateAction: updateAction,
                    isDeleteButtonDisabled: mode == .present),
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
                    showingCancelButton: mode == .push ? false : true,
                    activeDeleteButtonColor: Color.red
                )
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
                }))

        let cacheFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(cacheFilename)
        todoItemsBehaviorSubject.on(.next(fileCache.todoItems))

        if let url = cacheFilePath {
            fileCache.load(from: url)
        } else {
            print("Unable to load files, invalid path")
        }
        todoItemsBehaviorSubject.on(.next(fileCache.todoItems))
        todoItemsBehaviorSubject.subscribe (onNext: {items in
            if let newItem = items.first(where: { item in
                !fileCache.todoItems.contains(where: { todoItem in
                    todoItem.id == item.id
                })}) {
                let addRes = try? queryService.addTodo(payload: newItem)
                addRes?.subscribe(onSuccess: {item in
                    print("New task was appended", item)
                }, onFailure: {error in
                    print("Add task to server error", error)
                })
            }
            items.forEach { item in
                fileCache.addTask(item)
            }
            fileCache.todoItems.forEach { cacheItem in
                if !items.contains(where: {cacheItem.id == $0.id }) {
                    fileCache.removeTask(id: cacheItem.id)
                }
            }
            if let url = cacheFilePath {
                fileCache.save(to: url)
            } else {
                print("Unable to save files, invalid path")
            }
            queryService.handleNetwork(fileCache: fileCache)
        })
            .disposed(by: disposeBag)

        let todoListSubscription = queryService.getTodoList()
        todoListSubscription.subscribe { event in
                    switch event {
                    case .success(let todoItemsArray):
                        print("list got")
                        var filtered = todoItemsArray.filter{item in
                            return !fileCache.deleted.contains(where: {tombstone in
                                item.id == tombstone.itemId
                            })
                        }
                        fileCache.todoItems.forEach { item in
                            if !filtered.contains(where: {item.id == $0.id}) {
                                filtered.append(item)
                            }
                        }
                        
                        filtered = filtered.map {item in
                            if let fileCacheItem = fileCache.todoItems.first(where: {$0.id == item.id}) {
                                if fileCacheItem.updatedAt ?? 0 > item.updatedAt ?? 0 {
                                    return fileCacheItem
                                }
                            }
                            return item
                        }
                        
                        
                        todoItemsBehaviorSubject.on(.next(filtered))
                    case .failure(let error):
                        print("Error: ", error)
                    }
                }
                .disposed(by: disposeBag)
        let modeSubject: BehaviorSubject<HeaderViewModel.Mode> = .init(value: .show)

        let viewModelsObservable: Observable<[ToDoCellViewModel]> =
            Observable.combineLatest(todoItemsBehaviorSubject, modeSubject).map { (items: [TodoItem], mode: HeaderViewModel.Mode) in
            var resultedItems: [TodoItem]
            switch mode {
            case .show:
                resultedItems = items
            case .hide:
                resultedItems = items.filter {
                    !$0.done
                }
            }

            return resultedItems.map {
                ToDoCellViewModel(todoItem: $0,updateAction: updateAction, editAction: editAction,
                    deleteAction: deleteAction
                )
            }
        }

        viewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: NSLocalizedString("Tasks", comment: "")
            ),
            todoItemViewModelsObservable: viewModelsObservable,
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
