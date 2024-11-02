import SwiftUI

struct CalorieTrackProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Your CalorieTrackProfile")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            // Раздел отслеживания калорий
            VStack(alignment: .leading, spacing: 15) {
                Text("Track daily intake")
                    .font(.headline)
                
                HStack {
                    Text("Current calories count")
                    Spacer()
                    Text("2000 kcal/day")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                // Полосы прогресса для макроэлементов
                VStack(alignment: .leading, spacing: 10) {
                    ProgressRow(label: "Protein intake", value: 0.35)
                    ProgressRow(label: "Carbs intake", value: 0.50)
                    ProgressRow(label: "Fats intake", value: 0.15)
                }
                
                HStack {
                    Text("Recommended")
                    Spacer()
                    Text("Lorem ipsum")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)

            // Раздел с иконками активности
            VStack(spacing: 10) {
                Text("Choose Activity")
                    .font(.headline)

                HStack(spacing: 20) {
                    ActivityIconView(iconName: "figure.walk", label: "Walk for")
                    ActivityIconView(iconName: "figure.run", label: "Run for")
                    ActivityIconView(iconName: "dumbbell.fill", label: "Gym")
                    ActivityIconView(iconName: "brain.head.profile", label: "Mindful")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)

            // Кнопка Start now
            Button(action: {
                // Действие для кнопки
            }) {
                Text("Start now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct CalorieTrackProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieTrackProfileView()
            .previewLayout(.sizeThatFits)
    }
}
