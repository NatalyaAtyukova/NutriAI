import SwiftUI

struct RecipeGeneratorView: View {
    @State private var ingredients = ""
    @State private var recipe: String?
    @State private var isLoading = false

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
                .background(Color(UIColor.systemBackground)) // Background color adaptive to theme
            
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
                .background(Color.blue) // Keeping the button color blue for contrast
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
                        .background(Color(UIColor.secondarySystemBackground)) // Adaptive background color
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)) // Adaptive background color for entire view
    }
    
    private func generateRecipe() {
        let ingredientList = ingredients
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        isLoading = true
        FoodRecognitionService().generateRecipe(ingredients: ingredientList) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipeText):
                    self.recipe = recipeText
                case .failure(let error):
                    self.recipe = "Failed to generate recipe: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct RecipeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeGeneratorView()
            .preferredColorScheme(.dark) // Preview in dark mode
        RecipeGeneratorView()
            .preferredColorScheme(.light) // Preview in light mode
    }
}
