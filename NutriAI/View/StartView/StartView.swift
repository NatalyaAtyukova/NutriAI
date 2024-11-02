import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Заголовок
                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Text("Track your calories and reach your goals")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 40) // Отступ для визуального разделения
                
                // Примерные карточки целей
                VStack(spacing: 20) {
                    GoalCard(title: "Stay zen like a yoga master", iconName: "person")
                    GoalCard(title: "Explore nutrition by mood", iconName: "leaf")
                    
                    // Добавьте дополнительные карточки по мере необходимости
                }
                
                Spacer()
                
                // Кнопка для перехода к экрану профиля
                NavigationLink(destination: ProfileView()) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
