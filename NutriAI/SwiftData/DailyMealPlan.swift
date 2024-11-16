import Foundation
import SwiftData

@Model
class DailyMealPlan: Identifiable {
    @Attribute(.unique) var date: Date
    var meals: [String] // Список блюд (завтрак, обед, ужин и перекусы)
    
    init(date: Date, meals: [String]) {
        self.date = date
        self.meals = meals
    }
}
