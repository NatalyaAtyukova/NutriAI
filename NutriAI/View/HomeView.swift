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

                    HStack(spacing: 15) {
                        MoodCategoryView(title: "Healthy and", iconName: "heart.fill")
                        MoodCategoryView(title: "Exploring new", iconName: "sparkles")
                        MoodCategoryView(title: "Energized and", iconName: "bolt.fill")
                        MoodCategoryView(title: "Focused on", iconName: "brain.head.profile")
                    }
                    .padding(.horizontal)

                    // Раздел для распознавания еды
                    FoodRecognitionSection()

                    // Навигация по рекомендациям
                    NutritionRecommendationsSection()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MoodCategoryView: View {
    var title: String
    var iconName: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

struct FoodRecognitionSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Food Recognition")
                .font(.headline)
            
            Text("Take a photo of your meal and let NutriAI identify the foods and estimate the calories.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Действие для открытия камеры и распознавания продуктов
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Capture Food")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.vertical)
    }
}

struct NutritionRecommendationsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Explore nutrition options")
                .font(.headline)
            
            Text("Personalized plan for your goals")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Действие для открытия рекомендаций по питанию
            }) {
                HStack {
                    Text("Get started")
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.vertical)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
