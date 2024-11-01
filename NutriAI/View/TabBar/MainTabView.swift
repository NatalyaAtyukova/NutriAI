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
        }
        .accentColor(.blue)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
