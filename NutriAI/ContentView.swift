import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isRegistered") private var isRegistered: Bool = false

    var body: some View {
        Group {
            if isRegistered {
                // Загрузка основного интерфейса MainTabView для зарегистрированного пользователя
                MainTabView()
            } else {
                // Стартовый экран (или экран профиля)
                StartView()
                    .onDisappear {
                        // Установка isRegistered в true после успешного создания профиля
                        isRegistered = true
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
