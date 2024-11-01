import Foundation
import SwiftData

@Model
class ChatMessage {
    var message: String
    var isUserMessage: Bool
    var date: Date

    init(message: String, isUserMessage: Bool, date: Date = Date()) {
        self.message = message
        self.isUserMessage = isUserMessage
        self.date = date
    }
}
