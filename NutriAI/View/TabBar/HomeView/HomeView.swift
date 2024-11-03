import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedMood: String? // Состояние для выбранного настроения
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodRecord.date, order: .reverse) private var moodHistory: [MoodRecord] // Указание типа данных

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Приветствие
                    Text("Welcome to NutriAI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Text("Track your calories and reach your goals")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    // Категории настроения
                    Text("Explore nutrition by mood")
                        .font(.headline)
                        .padding(.leading)

                    // Сетка для категорий настроения
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        MoodCategoryView(title: "Healthy and", iconName: "heart.fill", isSelected: selectedMood == "Healthy and") {
                            selectMood("Healthy and")
                        }
                        MoodCategoryView(title: "Exploring new", iconName: "sparkles", isSelected: selectedMood == "Exploring new") {
                            selectMood("Exploring new")
                        }
                        MoodCategoryView(title: "Energized and", iconName: "bolt.fill", isSelected: selectedMood == "Energized and") {
                            selectMood("Energized and")
                        }
                        MoodCategoryView(title: "Focused on", iconName: "brain.head.profile", isSelected: selectedMood == "Focused on") {
                            selectMood("Focused on")
                        }
                    }
                    .padding(.horizontal)

                    // Раздел для распознавания еды
                    FoodRecognitionSection()

                    // Рекомендации по питанию
                    Text("Explore nutrition options")
                        .font(.headline)
                        .padding(.leading)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        NutritionRecommendationCard(title: "Balanced", description: "Customized")
                        NutritionRecommendationCard(title: "Scheduled eating", description: "Monthly fasting")
                        NutritionRecommendationCard(title: "Reduced carb intake plan", description: "Three-week")
                        NutritionRecommendationCard(title: "Natural food", description: "Three-week raw")
                        NutritionRecommendationCard(title: "Wheat-free eating plan", description: "Four-week")
                        NutritionRecommendationCard(title: "Plant-powered", description: "Four-week")
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadTodayMood) // Загрузка настроения при запуске
        }
    }
    
    private func selectMood(_ mood: String) {
        selectedMood = mood
        saveMoodSelection(mood)
    }

    // Функция для сохранения настроения
    private func saveMoodSelection(_ mood: String) {
        let newRecord = MoodRecord(moodTitle: mood, date: Date())
        modelContext.insert(newRecord)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save mood: \(error)")
        }
    }

    // Функция для загрузки настроения на текущий день
    private func loadTodayMood() {
        let today = Calendar.current.startOfDay(for: Date())
        if let todayMood = moodHistory.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            selectedMood = todayMood.moodTitle
        } else {
            selectedMood = nil
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
