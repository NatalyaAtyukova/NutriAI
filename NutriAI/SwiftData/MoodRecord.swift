import Foundation
import SwiftData

@Model
class MoodRecord {
    @Attribute var moodTitle: String
    @Attribute var date: Date
    
    init(moodTitle: String, date: Date = Date()) {
        self.moodTitle = moodTitle
        self.date = date
    }
}
