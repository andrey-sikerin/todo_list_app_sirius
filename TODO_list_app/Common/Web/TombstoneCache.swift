//
//  File.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 17.12.2021.
//

import Foundation

struct Tombstone: Codable {
    var itemId: String
    var deletedAt: Date
}
