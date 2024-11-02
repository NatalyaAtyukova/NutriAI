import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isRegistered") private var isRegistered: Bool = false

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var calorieGoal: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Age", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)

            TextField("Weight (kg)", text: $weight)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.decimalPad)

            TextField("Daily Calorie Goal", text: $calorieGoal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)

            Button(action: saveProfile) {
                Text("Save Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    private func saveProfile() {
        // Преобразование значений из String в нужные типы
        guard let age = Int(age),
              let weight = Double(weight),
              let calorieGoal = Int(calorieGoal) else {
            print("Ошибка преобразования данных")
            return
        }

        // Создание и сохранение профиля
        let profile = Profile(name: name, age: age, weight: weight, calorieGoal: calorieGoal)
        modelContext.insert(profile)
        
        // Обновление состояния регистрации и переход на HomeView
        isRegistered = true
        dismiss() // Закрывает экран ProfileView и возвращает в ContentView
    }
}
