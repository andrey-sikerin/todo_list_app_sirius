import Foundation

struct Tombstone: Codable {
    var itemId: String
    var deletedAt: Date
}
