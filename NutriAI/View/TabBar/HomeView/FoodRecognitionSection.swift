import SwiftUI

struct FoodRecognitionSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Заголовок
            Text("Food Recognition")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Описание
            Text("Take a photo of your meal and let NutriAI identify the foods and estimate the calories.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(5)
            
            // Кнопка
            Button(action: {
                // Действие для открытия камеры и распознавания продуктов
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
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FoodRecognitionSection()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
