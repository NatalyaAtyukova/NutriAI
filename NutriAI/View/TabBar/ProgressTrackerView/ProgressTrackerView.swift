import SwiftUI

struct ProgressTrackerView: View {
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Daily Calorie Intake")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            // График ежедневного потребления калорий
            VStack(alignment: .leading) {
                Text("Daily intake overview")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                    ForEach(0..<7, id: \.self) { day in
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: 25, height: CGFloat.random(in: 50...150))
                            
                            Text(days[day])
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding(.horizontal)
            
            // Цель по питанию
            VStack(alignment: .leading, spacing: 10) {
                Text("Nutrition goal")
                    .font(.headline)
                    .padding(.leading)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Track")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("2,500")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text("Profile")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("1,800")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    // Действие для установки цели
                }) {
                    Text("Set Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }
}

struct ProgressTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackerView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
