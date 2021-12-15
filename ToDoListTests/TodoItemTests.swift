//
//  TodoItemTests.swift
//  TODO_list_appTests
//
//  Created by Artem Goldenberg on 09.12.2021.
//

import XCTest
@testable import TODO_list_app

let date = Date(timeIntervalSince1970: 100_000)

class TodoItemTests: XCTestCase {
    
    var buyFood = TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low)
    var goRun = TodoItem(text: "Running is good", priority: .normal)
    var homework = TodoItem(text: "Copy It", deadline: date, priority: .high)

    func testExample() throws {
        XCTAssertNil(buyFood.deadline)
        XCTAssertEqual(buyFood.id, "BuyFoodIdString")
        XCTAssertEqual(goRun.priority.rawValue, "normal")
        XCTAssertEqual(homework.deadline, date)
        
        for item in [buyFood, goRun, homework] {
            let encoded = try! JSONEncoder().encode(item)
            let decoded = try! JSONDecoder().decode(TodoItem.self, from: encoded)
            XCTAssertTrue(decoded == item, "Assert failed, item1 != item2\nitem1: \(decoded)\nitem2: \(item)")
        }
    }

    func testEncodingPerfomance() throws {
        self.measure {
            _=try! JSONEncoder().encode(buyFood)
        }
    }
    
    func testDecodingPerfomance() throws {
        let encoded = try! JSONEncoder().encode(buyFood)
        self.measure {
            _=try! JSONDecoder().decode(TodoItem.self, from: encoded)
        }
    }
}

extension TodoItem: Equatable {
    public static func ==(lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text && lhs.deadline == rhs.deadline && lhs.priority == rhs.priority
    }
}
