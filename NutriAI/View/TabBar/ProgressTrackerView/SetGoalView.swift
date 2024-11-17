import SwiftUI
import HealthKit

// Вспомогательный экран для установки цели
struct SetGoalView: View {
    @Binding var goalCalories: Double
    @Environment(\.dismiss) var dismiss
    @State private var newGoal: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Set Your Calorie Goal")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            TextField("Enter calorie goal", text: $newGoal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button(action: {
                if let value = Double(newGoal), value > 0 {
                    goalCalories = value
                    UserDefaults.standard.set(value, forKey: "goalCalories") // Сохранение цели
                    dismiss()
                }
            }) {
                Text("Save Goal")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                    .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
