//
//  SnapshotTests.swift
//  TODO_list_appTests
//
//  Created by danuhaha on 16.12.2021.
//

import XCTest
import RxSwift
import SnapshotTesting
@testable import TODO_list_app

class SnapshotTests: XCTestCase {

    func testToDoCell() {
        let toDoItems = [
            TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low, done: true),
            TodoItem(text: "Running is good", priority: .normal, done: true),
            TodoItem(text: "Copy It", deadline: Date().addingTimeInterval(3600), priority: .high, done: false),
            TodoItem(text: "Cook yourself!", priority: .normal, done: true),
            TodoItem(text: "Enjoy", priority: .normal, done: false),
            TodoItem(text: "Sleeping is essential", deadline: Date().addingTimeInterval(3600 * 5), priority: .high, done: false)
        ]
        
        toDoItems.forEach {
            let toDoCell = ToDoCell(style: .default, reuseIdentifier: ToDoCell.identifier)
            toDoCell.configureCell(viewModel: .init(todoItem: $0, editAction: { _, _, _ in }, deleteAction: { _ in }))
            toDoCell.backgroundColor = Color.backgroundSecondary
            
            assertSnapshot(matching: toDoCell, as: .image, record: false)
        }

        let taskListViewController = TaskListViewController(
            strings: TaskListViewController.Strings(
                titleNavigationBarText: NSLocalizedString("Tasks", comment: "")
            ),
            todoItemViewModelsObservale: Observable.just(toDoItems.map({ .init(todoItem: $0, editAction: { _, _, _ in }, deleteAction: { _ in }) })),
            headerViewModel: HeaderViewModel(
                todoItemsObservable: Observable.just(toDoItems),
                strings: HeaderViewModel.Strings(
                    doneText: NSLocalizedString("Completed", comment: ""),
                    hideText: NSLocalizedString("Show", comment: ""),
                    showText: NSLocalizedString("Hide", comment: "")
                ),
                modeSubject: .init(value: .show)
            ),
            makeNewItemAction: { _ in }
        )

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


