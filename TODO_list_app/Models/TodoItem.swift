//
//  TodoItem.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 09.12.2021.
//

import Foundation

struct TodoItem {
    enum Priority: String {
        case low
        case normal
        case high
    }
    
    var id: String = UUID().uuidString
    var text: String
    var deadline: Date?
    var priority: Priority
}

extension TodoItem: Codable {
    enum CodingKeys: CodingKey {
        case id
        case text
        case deadline
        case priority
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        
        // if nil is decoded than deadline is assigned to nil automatically
        let stringDate = try values.decode(String?.self, forKey: .deadline)
        if let stringDate = stringDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            deadline = formatter.date(from: stringDate)
        }
        
        // if decode a nil then priority is not decoded, thus it's normal
        // if decode a value then priority is declared based on that value
        if let stringPriority = try values.decode(String?.self, forKey: .priority) {
            if let unwrappedPriority = Priority(rawValue: stringPriority) {
                priority = unwrappedPriority
            } else {
                fatalError("Unable to decode a TodoItem, invalid priority: \(stringPriority)")
            }
        } else {
            priority = Priority.normal
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        
        // if priority is normal then we don't encode it
        if priority == .normal {
            try container.encode(Optional<String>.none.self, forKey: .priority)
        } else {
            try container.encode(priority.rawValue, forKey: .priority)
        }
        
        // if there is a deadline, encode it, else don't
        if let date = deadline {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            let stringDate = formatter.string(from: date)
            try container.encode(stringDate, forKey: .deadline)
        } else {
            try container.encode(String?.none, forKey: .deadline)
        }
    }
}
