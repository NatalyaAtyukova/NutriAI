import SwiftUI
import HealthKit

struct ProgressTrackerView: View {
    @State private var weeklyCalories: [Double] = Array(repeating: 0, count: 7) // Реальные данные из HealthKit
    @State private var goalCalories: Double = UserDefaults.standard.double(forKey: "goalCalories") // Целевая норма калорий
    @State private var currentCalories: Double = 0 // Потребленные калории за текущий день
    @State private var isLoading = false // Флаг загрузки данных
    @State private var isSettingGoal = false // Показ модального окна для установки цели

    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let healthKitManager = HealthKitManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Daily Calorie Intake")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            // График ежедневного потребления калорий
            VStack(alignment: .leading) {
                Text("Daily intake overview")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                    ForEach(0..<7, id: \.self) { day in
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: 25, height: CGFloat(weeklyCalories[day] / goalCalories * 150))
                            
                            Text(days[day])
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding(.horizontal)

            // Цель по питанию
            VStack(alignment: .leading, spacing: 10) {
                Text("Nutrition goal")
                    .font(.headline)
                    .padding(.leading)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Goal")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(Int(goalCalories)) kcal")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text("Today")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(Int(currentCalories)) kcal")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    isSettingGoal = true // Открытие модального окна
                }) {
                    Text("Set Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .sheet(isPresented: $isSettingGoal) {
            SetGoalView(goalCalories: $goalCalories)
        }
        .onAppear(perform: fetchCalories) // Загрузка данных при появлении
    }

    private func fetchCalories() {
        isLoading = true

        // Получение данных за текущую неделю
        healthKitManager.fetchWeeklyCalories { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let result = result {
                    self.weeklyCalories = result
                    self.currentCalories = result[Calendar.current.component(.weekday, from: Date()) - 1]
                } else {
                    print("Ошибка при получении данных: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                }
            }
        }
    }
}



struct ProgressTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackerView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
