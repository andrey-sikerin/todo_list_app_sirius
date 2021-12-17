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
    
    private static let tombstonesSaveKey = "DeletedItems"
    
    private var deleted: [Tombstone] = []
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
        items[task.id] = task
        return true
    }
    
    /// removes task from the list based on id
    /// returns the deleted element if id is in the `todoItems`
    /// if not, return `nil`
    @discardableResult
    func removeTask(id: String) -> TodoItem? {
        if items[id] != nil {
            deleted.append(
                Tombstone(
                    itemId: id,
                    deletedAt: Date()
                )
            )
        }
        return items.removeValue(forKey: id)
    }
    
    @discardableResult
    func removeTombstone(id: String) -> Bool {
        if let tombIndex = deleted.firstIndex(where: {$0.itemId == id}) {
            deleted.remove(at: tombIndex)
            return true
        }
        return false
    }
    
    func save(to file: URL) {
        guard let encoded = try? JSONEncoder().encode(todoItems) else {
            print("Failed to encode items: \(todoItems)")
            return
        }
        do {
            UserDefaults.standard.set(deleted, forKey: Self.tombstonesSaveKey)
            try manager.write(encoded, file)
        } catch(let error) {
            print("Failed saving items to file: \(file)\ndescription: \(error.localizedDescription)")
        }
    }
    
    func load(from file: URL) {
        if let tombstones = UserDefaults.standard.value(forKey: Self.tombstonesSaveKey) as? [Tombstone] {
            deleted = tombstones
        }
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
