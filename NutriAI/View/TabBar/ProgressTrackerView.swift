import SwiftUI

struct ProgressTrackerView: View {
    var body: some View {
        VStack {
            Text("Progress Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Track your daily, weekly, and monthly progress.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            Spacer()

            // Примерный трекер прогресса
            Text("Progress tracking interface goes here")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

            Spacer()
        }
        .padding()
    }
}
