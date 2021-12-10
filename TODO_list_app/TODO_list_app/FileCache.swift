//
//  FileCache.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 09.12.2021.
//

import Foundation
import OrderedCollections

class FileCache {
    struct FileManager {
        let write: (Data, URL) throws -> Void
        let read: (URL) throws -> Data
    }
    
    private var items: OrderedDictionary<String, TodoItem> = [:]
    var todoItems: [TodoItem] {
        items.values.elements
    }
    private let manager: FileManager
    
    init(manager: FileManager) {
        self.manager = manager
    }
    
    /// add task with unique id
    /// returns true if succeed
    /// false if failed
    @discardableResult
    func addTask(_ task: TodoItem) -> Bool {
        if items[task.id] != nil {
            return false
        }
        items[task.id] = task
        return true
    }
    
    /// removes task from the list based on id
    /// returns the deleted element if id is in the `todoItems`
    /// if not, return `nil`
    @discardableResult
    func removeTask(id: String) -> TodoItem? {
        return items.removeValue(forKey: id)
    }
    
    func save(to file: URL) {
        guard let encoded = try? JSONEncoder().encode(todoItems) else {
            print("Failed to encode items: \(todoItems)")
            return
        }
        do {
            try manager.write(encoded, file)
        } catch(let error) {
            print("Failed saving items to file: \(file)\ndescription: \(error.localizedDescription)")
        }
    }
    
    func load(from file: URL) {
        do {
            let itemsData = try manager.read(file)
            let decoded = try JSONDecoder().decode([TodoItem].self, from: itemsData)
            decoded.forEach { item in
                items[item.id] = item
            }
        } catch(let error) {
            print("Failed loading items from file: \(file)\ndescription: \(error.localizedDescription)")
        }
    }
}
