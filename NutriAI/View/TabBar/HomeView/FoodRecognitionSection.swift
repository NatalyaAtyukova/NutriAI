import SwiftUI

struct FoodRecognitionSection: View {
    @StateObject private var recognitionService = FoodRecognitionService()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var recognizedFoods: [String] = []
    @State private var recognizedFruits: [String] = []
    @State private var recognizedVegetables: [String] = []
    @State private var totalCalories: Int = 0
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Food Recognition")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Take a photo of your meal and let NutriAI identify the foods and estimate the calories.")
                .font(.subheadline)
                .foregroundColor(.secondary)
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
            .disabled(isLoading)
            
            if !recognizedFoods.isEmpty || !recognizedFruits.isEmpty || !recognizedVegetables.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    if !recognizedFoods.isEmpty {
                        Text("Recognized Foods: \(recognizedFoods.joined(separator: ", "))")
                    }
                    if !recognizedFruits.isEmpty {
                        Text("Recognized Fruits: \(recognizedFruits.joined(separator: ", "))")
                    }
                    if !recognizedVegetables.isEmpty {
                        Text("Recognized Vegetables: \(recognizedVegetables.joined(separator: ", "))")
                    }
                }
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top)
            }
            
            if totalCalories > 0 {
                Text("Total Calories: \(totalCalories) kcal")
                    .font(.headline)
                    .foregroundColor(.green)
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
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func analyzeImage() {
        guard let selectedImage = selectedImage else {
            print("Изображение не выбрано")
            return
        }
        
        isLoading = true
        recognitionService.recognizeAllCategories(image: selectedImage) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let categories):
                    recognizedFoods = categories["Food"] ?? []
                    recognizedFruits = categories["Fruit"] ?? []
                    recognizedVegetables = categories["Vegetable"] ?? []
                    
                    let allRecognizedItems = recognizedFoods + recognizedFruits + recognizedVegetables
                    calculateCaloriesUsingOpenAI(recognizedItems: allRecognizedItems) // Подсчет калорий
                    
                    print("Распознанные продукты: \(recognizedFoods)")
                    print("Распознанные фрукты: \(recognizedFruits)")
                    print("Распознанные овощи: \(recognizedVegetables)")
                case .failure(let error):
                    recognizedFoods = []
                    recognizedFruits = []
                    recognizedVegetables = []
                    totalCalories = 0
                    print("Ошибка распознавания: \(error.localizedDescription)")
                }
            }
        }
    }

    private func calculateCaloriesUsingOpenAI(recognizedItems: [String]) {
        guard !recognizedItems.isEmpty else {
            totalCalories = 0
            return
        }
        
        isLoading = true
        recognitionService.estimateCalories(ingredients: recognizedItems) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let calorieEstimate):
                    if let calories = Int(calorieEstimate.filter("0123456789".contains)), calories > 0 {
                        totalCalories = calories
                    } else {
                        totalCalories = 0
                        print("Некорректный ответ OpenAI: \(calorieEstimate)")
                    }
                case .failure(let error):
                    totalCalories = 0
                    print("Ошибка подсчета калорий: \(error.localizedDescription)")
                }
            }
        }
    }
}
