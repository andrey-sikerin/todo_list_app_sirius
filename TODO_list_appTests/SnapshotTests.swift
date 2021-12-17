//
//  SnapshotTests.swift
//  TODO_list_appTests
//
//  Created by danuhaha on 16.12.2021.
//

import XCTest
import SnapshotTesting
@testable import TODO_list_app

class SnapshotTests: XCTestCase {

    func testToDoCell() {
        let toDoItems = [
            TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low),
            TodoItem(text: "Running is good", priority: .normal),
            TodoItem(text: "Copy It", deadline: Date().addingTimeInterval(3600), priority: .high),
            TodoItem(text: "Cook yourself!", priority: .normal),
            TodoItem(text: "Enjoy", priority: .normal),
            TodoItem(text: "Sleeping is essential", deadline: Date().addingTimeInterval(3600 * 5), priority: .high)
        ]

        var toDoCells = [ToDoCell]()
        toDoItems.forEach {
            let toDoCell = ToDoCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ToDoCell.identifier)
            toDoCell.configureCell(todoItem: $0)
            toDoCell.backgroundColor = Color.backgroundSecondary
            toDoCells.append(toDoCell)
        }

        let navigationController: UINavigationController
        var aNavigationController: UINavigationController?
        let taskListGraph = TaskListGraph(
            rootRouter: RootRouter(
                pushAction: {
                    aNavigationController?.pushViewController($0, animated: true)
                },
                popAction: {
                    aNavigationController?.popViewController(animated: true)
                },
                presentAction: {
                    aNavigationController?.present($0, animated: true, completion: nil)
                },
                dismissAction: {
                    $0.dismiss(animated: true, completion: nil)
                }

            )
        )
        navigationController = UINavigationController(
            rootViewController: taskListGraph.viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        aNavigationController = navigationController


        let transitionToEditVC: (TransitionMode, UIViewController) -> Void = { mode, vc in

            let transitionToTaskListVC: PopAction
            switch mode {
            case .push: transitionToTaskListVC = {
                taskListGraph.rootRouter.popAction()
                }
            case .present: transitionToTaskListVC = {
                taskListGraph.rootRouter.dismissAction(vc)
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
                    buttonTextColor: .black,
                    buttonPressedTextColor: .black, showingCancelButton: true
                ),
                transitionToTaskList: transitionToTaskListVC
            )

            switch mode {
            case .push: taskListGraph.rootRouter.pushAction(editTaskVC)
            case .present: taskListGraph.rootRouter.presentAction(UINavigationController(rootViewController: editTaskVC))
            }

        }

        let taskListViewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: NSLocalizedString("Tasks", comment: ""),
                doneAmountLabelText: NSLocalizedString("Completed", comment: ""),
                showDoneButtonText: NSLocalizedString("Show", comment: ""),
                hideDoneButtonText: NSLocalizedString("Hide", comment: "")
            ),
            transitionToEdit: transitionToEditVC,
            cachedItems: toDoItems,
            todoItemsSubscription: nil
        )

        toDoCells.forEach {
            assertSnapshot(matching: $0, as: .image)
        }

        assertSnapshot(matching: taskListViewController, as: .image)

    }


        override func setUpWithError() throws {
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }

        override func tearDownWithError() throws {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        func testExample() throws {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct results.
        }

        func testPerformanceExample() throws {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }

    }


