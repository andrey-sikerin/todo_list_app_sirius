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
            let toDoCell = ToDoCell(style: .default, reuseIdentifier: ToDoCell.identifier)
            toDoCell.configureCell(viewModel: ToDoCellViewModel(todoItem: $0))
            toDoCell.backgroundColor = Color.backgroundSecondary
            toDoCells.append(toDoCell)
        }

        let taskListViewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: "Tasks",
                doneAmountLabelText: "Completed",
                showDoneButtonText: "Show",
                hideDoneButtonText: "Hide"
            ),
            transitionToEdit: { _, _ in },
                todoItemViewModels: toDoItems.map { .init(todoItem: $0) },
            todoItemsSubscription: nil
        )

        toDoCells.forEach {
            assertSnapshot(matching: $0, as: .image, record: false)
        }

        assertSnapshot(matching: taskListViewController, as: .image, record: false)

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


