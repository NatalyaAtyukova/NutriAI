import SwiftUI

struct ChatCard: View {
    let message: String
    let isUserMessage: Bool

    var body: some View {
        HStack {
            if isUserMessage {
                Spacer()
            }

            Text(message)
                .padding()
                .background(isUserMessage ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .foregroundColor(isUserMessage ? .blue : .green)
                .cornerRadius(12)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: isUserMessage ? .trailing : .leading)
                .multilineTextAlignment(isUserMessage ? .trailing : .leading)
                .fixedSize(horizontal: false, vertical: true) // Позволяет тексту расширяться по вертикали

            if !isUserMessage {
                Spacer()
            }
        }
        .padding(isUserMessage ? .leading : .trailing, 40)
        .padding(.vertical, 5)
    }
}
