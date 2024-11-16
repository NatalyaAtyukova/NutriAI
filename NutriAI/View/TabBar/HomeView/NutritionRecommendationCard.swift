import SwiftUI

struct NutritionRecommendationCard: View {
    var title: String
    var description: String
    var isSelected: Bool // Показывает, выбрана ли карточка
    var isLoading: Bool // Показывает, идет ли загрузка
    var onTap: () -> Void // Обработчик нажатия
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            LinearGradient(
                gradient: Gradient(colors: isSelected ? [Color.blue, Color.purple] : [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: isSelected ? Color.purple.opacity(0.3) : Color.teal.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
        )
        .padding(.vertical, 5)
        .onTapGesture {
            onTap() // Вызов обработчика нажатия
        }
    }
}

struct NutritionRecommendationCard_Previews: PreviewProvider {
    static var previews: some View {
        NutritionRecommendationCard(title: "Balanced", description: "Customized plan", isSelected: true, isLoading: true) {
            print("Card tapped")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
