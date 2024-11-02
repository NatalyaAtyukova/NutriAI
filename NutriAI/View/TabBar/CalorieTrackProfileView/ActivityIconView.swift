import SwiftUI

// Компонент для иконки активности
struct ActivityIconView: View {
    var iconName: String
    var label: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}
