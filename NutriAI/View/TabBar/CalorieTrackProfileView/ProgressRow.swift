import SwiftUI

// Компонент для строки с полосой прогресса
struct ProgressRow: View {
    var label: String
    var value: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label)
                Spacer()
                Text("\(Int(value * 100))%")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            ProgressBar(value: value)
                .frame(height: 8)
                .cornerRadius(4)
        }
    }
}
