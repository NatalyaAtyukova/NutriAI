import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedMood: String? // Состояние для выбранного настроения
    @State private var isGenerating = false // Флаг для отображения загрузки
    @State private var generatedMeals: [String] = [] // Список сгенерированных блюд
    @State private var selectedCategory: IdentifiableCategory? // Выбранная категория
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
                        .foregroundColor(.primary) // Адаптивный цвет
                        .padding(.top, 20)
                    
                    Text("Track your calories and reach your goals")
                        .font(.title2)
                        .foregroundColor(.secondary) // Адаптивный цвет
                        .padding(.bottom, 20)
                    
                    // Категории настроения
                    Text("Explore nutrition by mood")
                        .font(.headline)
                        .foregroundColor(.primary) // Адаптивный цвет
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
                        .foregroundColor(.primary) // Адаптивный цвет
                        .padding(.leading)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        NutritionRecommendationCard(title: "Balanced", description: "Customized", isSelected: selectedCategory?.name == "Balanced", isLoading: isGenerating) {
                            generatePlan(for: "Balanced")
                        }
                        NutritionRecommendationCard(title: "Scheduled eating", description: "Monthly fasting", isSelected: selectedCategory?.name == "Scheduled eating", isLoading: isGenerating) {
                            generatePlan(for: "Scheduled eating")
                        }
                        NutritionRecommendationCard(title: "Reduced carb intake plan", description: "Three-week", isSelected: selectedCategory?.name == "Reduced carb intake", isLoading: isGenerating) {
                            generatePlan(for: "Reduced carb intake")
                        }
                        NutritionRecommendationCard(title: "Natural food", description: "Three-week raw", isSelected: selectedCategory?.name == "Natural food", isLoading: isGenerating) {
                            generatePlan(for: "Natural food")
                        }
                        NutritionRecommendationCard(title: "Wheat-free eating plan", description: "Four-week", isSelected: selectedCategory?.name == "Wheat-free eating", isLoading: isGenerating) {
                            generatePlan(for: "Wheat-free eating")
                        }
                        NutritionRecommendationCard(title: "Plant-powered", description: "Four-week", isSelected: selectedCategory?.name == "Plant-powered", isLoading: isGenerating) {
                            generatePlan(for: "Plant-powered")
                        }
                    }
                    .padding(.horizontal)
                    
                    if isGenerating {
                        ProgressView("Generating your meal plan...")
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadTodayMood) // Загрузка настроения при запуске
            .sheet(item: $selectedCategory) { category in
                DailyMealPlanView(category: category.name, generatedMeals: generatedMeals)
            }
        }
    }
    
    private func selectMood(_ mood: String) {
        selectedMood = mood
        saveMoodSelection(mood)
    }
    
    private func saveMoodSelection(_ mood: String) {
        let newRecord = MoodRecord(moodTitle: mood, date: Date())
        modelContext.insert(newRecord)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save mood: \(error)")
        }
    }
    
    private func loadTodayMood() {
        let today = Calendar.current.startOfDay(for: Date())
        if let todayMood = moodHistory.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            selectedMood = todayMood.moodTitle
        } else {
            selectedMood = nil
        }
    }
    
    private func generatePlan(for category: String) {
        isGenerating = true
        selectedCategory = IdentifiableCategory(name: category) // Выделение выбранной категории
        
        let prompt = """
        Generate a one-day meal plan for a \(category) diet. Include breakfast, lunch, snack, and dinner. Format as: 
        "Breakfast: ..., Lunch: ..., Snack: ..., Dinner: ...".
        """
        
        FoodRecognitionService().generateDailyMealPlan(for: prompt) { result in
            DispatchQueue.main.async {
                self.isGenerating = false
                switch result {
                case .success(let meals):
                    if meals.isEmpty {
                        print("Generated an empty meal plan")
                    }
                    self.generatedMeals = meals
                case .failure(let error):
                    self.generatedMeals = ["Error generating plan: \(error.localizedDescription)"]
                    print("Error generating plan: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
}


// Обертка для строки, чтобы соответствовать протоколу Identifiable
struct IdentifiableCategory: Identifiable {
    let id = UUID()
    let name: String
}
