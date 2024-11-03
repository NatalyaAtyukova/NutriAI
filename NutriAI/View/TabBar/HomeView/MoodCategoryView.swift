import SwiftUI
import SwiftData

struct MoodCategoryView: View {
    var title: String
    var iconName: String
    var isSelected: Bool // Новый параметр для проверки выбранного состояния
    var action: () -> Void
    
    @Environment(\.modelContext) private var modelContext // Доступ к базе данных
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color.white) // Меняем фон при выборе
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2) // Добавляем обводку
        )
        .cornerRadius(10)
        .shadow(radius: 5)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                saveMoodSelection() // Сохраняем выбор настроения
                action() // Обновляем выбранное настроение в HomeView
            }
        }
    }
    
    private func saveMoodSelection() {
        let newRecord = MoodRecord(moodTitle: title)
        modelContext.insert(newRecord) // Сохраняем запись в базу данных
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save mood: \(error)")
        }
    }
}
