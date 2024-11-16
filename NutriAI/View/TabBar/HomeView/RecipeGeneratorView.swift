import SwiftUI

struct RecipeGeneratorView: View {
    @State private var ingredients = ""
    @State private var recipe: String? // Сгенерированный рецепт
    @State private var isLoading = false // Флаг загрузки

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("AI Recipe Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Enter ingredients to generate a recipe:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextField("e.g., chicken, rice, bell peppers", text: $ingredients)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical)
            
            Button(action: generateRecipe) {
                HStack {
                    if isLoading {
                        ProgressView()
                    }
                    Text("Generate Recipe")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .disabled(isLoading || ingredients.isEmpty)

            if let recipe = recipe {
                Text("Generated Recipe:")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                ScrollView {
                    Text(recipe)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func generateRecipe() {
        let ingredientList = ingredients
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        isLoading = true

        // Заглушка вместо интеграции с FoodRecognitionService
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Имитация задержки
            self.isLoading = false
            self.recipe = "Recipe generation for: \(ingredientList.joined(separator: ", ")) (Placeholder output)"
        }
    }
}

struct RecipeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeGeneratorView()
    }
}
