//
//  CacheFileTests.swift
//  TODO_list_appTests
//
//  Created by Artem Goldenberg on 09.12.2021.
//

import XCTest
@testable import TODO_list_app

class CacheFileTests: XCTestCase {
    
    var buyFood = TodoItem(id: "BuyFoodIdString", text: "Working for food", priority: .low)
    var goRun = TodoItem(text: "Running is good", priority: .normal)
    var homework = TodoItem(text: "Copy It", deadline: date, priority: .high)
    
    let filename = getDocumentsDirectory().appendingPathComponent("todoItems.json")
    var fileCache: FileCache!
    var dict: [URL : Data] = [:]

    override func setUpWithError() throws {
        let fileManager = FileCache.FileManager(write: { [unowned self] data, url in
            self.dict[url] = data
        }, read: { [unowned self] url in
            self.dict[url]!
        })
        
        fileCache = FileCache(manager: fileManager)
        fileCache.addTask(buyFood)
        fileCache.addTask(goRun)
        fileCache.addTask(homework)
    }
    
    override func tearDownWithError() throws {
        dict.removeAll()
    }

    func testExample() throws {
        XCTAssertEqual(fileCache.todoItems.count, 3)
        fileCache.removeTask(id: "BuyFoodIdString")
        XCTAssertEqual(fileCache.todoItems.count, 2)
        let shave = TodoItem(id: "ShavingIdString", text: "Do shave hard", priority: .normal)
        fileCache.addTask(shave)
        XCTAssertEqual(fileCache.todoItems.count, 3)
        XCTAssertNil(fileCache.todoItems.firstIndex(of: buyFood))
        
        let items = fileCache.todoItems
        fileCache.save(to: filename)
        fileCache.removeTask(id: shave.id)
        fileCache.removeTask(id: goRun.id)
        fileCache.removeTask(id: homework.id)
        XCTAssertNotEqual(items, fileCache.todoItems)
        XCTAssertEqual(fileCache.todoItems.count, 0)
                
        fileCache.load(from: filename)
        XCTAssertEqual(fileCache!.todoItems, items)
    }
    
    func testUniqueIds() throws {
        let goOut = TodoItem(id: "SameId", text: "It is good for your health", priority: .normal)
        let goHome = TodoItem(id: "SameId", text: "Let's come home", priority: .normal)
        fileCache.addTask(goOut)
        XCTAssertFalse(fileCache.addTask(goHome))
    }
    
    func testRemovingIds() throws {
        XCTAssertNotNil(fileCache.removeTask(id: "BuyFoodIdString"))
        XCTAssertNil(fileCache.removeTask(id: "BuyFoodIdString"))
    }
}

fileprivate func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
