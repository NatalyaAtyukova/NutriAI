import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Вкладка Главная
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // Вкладка Чат-бот
            ChatBotView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("ChatBot")
                }
            
            // Вкладка Трекер прогресса
            ProgressTrackerView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
            
            // Вкладка трекер каллорий
            CalorieTrackProfileView()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Calorie Tracker")
                }
            
        }
        .accentColor(.blue)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
