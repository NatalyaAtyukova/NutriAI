import SwiftUI

struct DailyMealPlanView: View {
    var category: String
    var generatedMeals: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок
                Text("\(category) Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                // Подзаголовок
                Text("Here’s your customized daily meal plan:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)

                // Список сгенерированных блюд
                ForEach(generatedMeals, id: \.self) { meal in
                    HStack(alignment: .top) {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.teal)
                            .font(.headline)
                            .padding(.top, 5)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(meal)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(nil)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("\(category) Plan", displayMode: .inline)
    }
}

struct DailyMealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DailyMealPlanView(category: "Balanced", generatedMeals: [
            "Breakfast: Oatmeal with fresh fruits",
            "Lunch: Grilled chicken with quinoa and steamed broccoli",
            "Snack: Mixed nuts and a banana",
            "Dinner: Baked salmon with roasted asparagus and a side salad"
        ])
    }
}
