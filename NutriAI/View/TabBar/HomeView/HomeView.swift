import SwiftUI

struct HomeView: View {
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
                        MoodCategoryView(title: "Healthy and", iconName: "heart.fill")
                        MoodCategoryView(title: "Exploring new", iconName: "sparkles")
                        MoodCategoryView(title: "Energized and", iconName: "bolt.fill")
                        MoodCategoryView(title: "Focused on", iconName: "brain.head.profile")
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
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
