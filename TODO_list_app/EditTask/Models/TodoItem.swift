import Foundation

struct TodoItem {
    enum Priority: String {
        case low = "low"
        case normal = "basic"
        case high = "important"
    }

    var id: String = UUID().uuidString
    var text: String
    var deadline: Date?
    var priority: Priority
    var createdAt: Double = NSDate().timeIntervalSince1970
    var updatedAt: Double?
    var done: Bool = false
    var isDirty: Bool = false
}

extension TodoItem: Codable {
    enum CodingKeys: CodingKey {
        case id
        case text
        case deadline
        case importance
        case created_at
        case updated_at
        case done
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        createdAt = try values.decode(Double.self, forKey: .created_at)
        updatedAt = try values.decode(Double?.self, forKey: .updated_at)
        done = try values.decode(Bool.self, forKey: .done)

        // if nil is decoded than deadline is assigned to nil automatically
        let stringDate = try values.decode(String?.self, forKey: .deadline)
        if let stringDate = stringDate {
            deadline =  DateFormatter.todoItemFormatter.date(from: stringDate)
        }

        // if decode a nil then priority is not decoded, this it's normal
        // if decode a value then priority is declared based on that value
        if let stringPriority = try values.decode(String?.self, forKey: .importance) {
            if let unwrappedPriority = Priority(rawValue: stringPriority) {
                priority = unwrappedPriority
            } else {
                fatalError("Unable to decode a TodoItem, invalid priority: \(stringPriority)")
            }
        } else {
            priority = .normal
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(createdAt, forKey: .created_at)
        try container.encode(done, forKey: .done)
        try container.encode(updatedAt, forKey: .updated_at)
        try container.encode(priority.rawValue, forKey: .importance)

        // if there is a deadline, encode it, else don't
        if let date = deadline {
            let stringDate = DateFormatter.todoItemFormatter.string(from: date)
            try container.encode(stringDate, forKey: .deadline)
        } else {
            try container.encode(String?.none, forKey: .deadline)
        }
    }
}

fileprivate extension DateFormatter {
    static let todoItemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        return formatter
    }()
}


extension TodoItem {
  static let emptyItem = {
    TodoItem(id: UUID().uuidString,
             text: "",
             deadline: nil,
             priority: .normal,
             createdAt: NSDate().timeIntervalSince1970,
             updatedAt: nil,
             done: false)

  }()
}
