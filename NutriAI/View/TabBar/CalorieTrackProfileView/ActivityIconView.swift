import SwiftUI

struct ActivityIconView: View {
    var iconName: String
    var label: String
    var isSelected: Bool // Indicates if the activity is selected
    var onTap: () -> Void // Action to perform on tap

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(isSelected ? .white : .primary)

            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .blue : .primary)
        }
        .onTapGesture {
            onTap()
        }
    }
}
