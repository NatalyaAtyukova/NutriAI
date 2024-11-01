import Foundation
import SwiftData

@Model
class Profile {
    var name: String
    var age: Int
    var weight: Double
    var calorieGoal: Int

    init(name: String, age: Int, weight: Double, calorieGoal: Int) {
        self.name = name
        self.age = age
        self.weight = weight
        self.calorieGoal = calorieGoal
    }
}
