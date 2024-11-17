import SwiftUI

struct ActivitySummaryCard: View {
    var activityName: String
    var caloriesBurned: Int
    var duration: Int // В секундах

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(activityName)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Calories Burned")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(caloriesBurned) kcal")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(duration / 60) min")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct ActivitySummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySummaryCard(activityName: "Running", caloriesBurned: 250, duration: 1200)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
