import SwiftUI
import PhotosUI
import Vision

struct FoodRecognitionSection: View {
    @State private var selectedImage: UIImage? // Изображение, выбранное пользователем
    @State private var isShowingImagePicker = false
    @State private var recognizedFoods: [String] = [] // Распознанные продукты
    @State private var recipe: String? // Сгенерированный рецепт
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Food Recognition")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary) // Адаптивный цвет
            
            Text("Take a photo of your meal and let NutriAI identify the foods and estimate the calories.")
                .font(.subheadline)
                .foregroundColor(.secondary) // Адаптивный цвет
                .lineSpacing(5)
            
            Button(action: {
                isShowingImagePicker = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.headline)
                    Text("Capture Food")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .cornerRadius(15)
                .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .sheet(isPresented: $isShowingImagePicker, content: {
                ImagePicker(selectedImage: $selectedImage, onImagePicked: analyzeImage)
            })
            
            if !recognizedFoods.isEmpty {
                Text("Recognized Ingredients: \(recognizedFoods.joined(separator: ", "))")
                    .font(.headline)
                    .foregroundColor(.primary) // Адаптивный цвет
                    .padding(.top)
                
                Button("Generate Recipe") {
                    generateRecipe()
                }
                .foregroundColor(.blue) // Адаптивный цвет кнопки для рецепта
                .padding()
            }
            
            if let recipe = recipe {
                Text("Recipe: \(recipe)")
                    .font(.headline)
                    .foregroundColor(.blue) // Адаптивный цвет
                    .padding(.top)
            }

            if isLoading {
                ProgressView("Processing...")
                    .padding()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground)) // Адаптивный цвет фона
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func analyzeImage() {
        guard let selectedImage = selectedImage else { return }
        
        isLoading = true
        FoodRecognitionService().recognizeFoodWithVision(image: selectedImage) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let foods):
                    recognizedFoods = foods
                case .failure(let error):
                    recognizedFoods = ["Error: \(error.localizedDescription)"]
                }
            }
        }
    }
    
    private func generateRecipe() {
        isLoading = true
        FoodRecognitionService().generateRecipe(ingredients: recognizedFoods) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let generatedRecipe):
                    recipe = generatedRecipe
                case .failure(let error):
                    recipe = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
