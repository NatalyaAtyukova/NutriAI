import SwiftData
import Foundation

@Model
class ActivityRecord: Identifiable {
    @Attribute(.unique) var id: UUID = UUID() // Уникальный идентификатор
    var activityName: String // Название активности
    var duration: Int // Продолжительность в секундах
    var caloriesBurned: Int // Потраченные калории
    var date: Date // Дата записи

    // Пользовательский инициализатор
    init(activityName: String, duration: Int, caloriesBurned: Int, date: Date) {
        self.activityName = activityName
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
    }
}
