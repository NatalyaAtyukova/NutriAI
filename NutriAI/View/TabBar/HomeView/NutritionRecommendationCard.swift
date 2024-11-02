import SwiftUI

struct NutritionRecommendationCard: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: Color.teal.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .padding(.vertical, 5)
    }
}

struct NutritionRecommendationCard_Previews: PreviewProvider {
    static var previews: some View {
        NutritionRecommendationCard(title: "Balanced", description: "Customized plan")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
