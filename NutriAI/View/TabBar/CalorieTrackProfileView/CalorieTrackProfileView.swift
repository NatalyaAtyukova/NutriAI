import SwiftUI
import HealthKit

struct CalorieTrackProfileView: View {
    @State private var selectedActivity: String? // Tracks the selected activity
    @State private var loggedActivities: [String] = [] // Tracks user-selected activities
    @State private var healthData: [String: String] = [:] // HealthKit data
    @State private var isLoading = false // Loading state for HealthKit
    @State private var timerActive = false // State to track if the timer is active
    @State private var elapsedTime: Int = 0 // Tracks elapsed time in seconds
    @State private var caloriesPerMinute: Double? // Calories burned per minute
    @Environment(\.modelContext) private var modelContext // Environment for saving records

    private let activities = [
        ("figure.walk", "Walking"),
        ("figure.run", "Running"),
        ("bicycle", "Cycling"),
        ("figure.strengthtraining.traditional", "Workout"),
        ("leaf", "Yoga"),
        ("bed.double", "Sleep")
    ]

    private let healthKitManager = HealthKitManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Your CalorieTrackProfile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                // Calorie Tracking Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Track daily intake")
                        .font(.headline)

                    HStack {
                        Text("Current calories count")
                        Spacer()
                        Text(healthData["Active Energy"] ?? "N/A")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)

                // Activity Selection Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Choose Activity")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(activities, id: \.0) { (icon, label) in
                            ActivityIconView(
                                iconName: icon,
                                label: label,
                                isSelected: selectedActivity == label,
                                onTap: { selectActivity(label) }
                            )
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)

                // Exercise Timer and Calorie Tracker
                if let selectedActivity = selectedActivity {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("\(selectedActivity) Session")
                            .font(.headline)

                        HStack {
                            Text("Elapsed Time:")
                            Spacer()
                            Text("\(elapsedTime / 60)m \(elapsedTime % 60)s")
                        }

                        if let caloriesPerMinute = caloriesPerMinute {
                            HStack {
                                Text("Calories Burned per Minute:")
                                Spacer()
                                Text(String(format: "%.2f kcal/min", caloriesPerMinute))
                            }
                        } else {
                            Text("Calories Burned per Minute: N/A")
                        }

                        Button(action: toggleTimer) {
                            Text(timerActive ? "Stop Session" : "Start Session")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(timerActive ? Color.red : Color.blue)
                                .cornerRadius(10)
                                .shadow(color: timerActive ? Color.red.opacity(0.4) : Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }

                // Logged Activities
                if !loggedActivities.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Activities")
                            .font(.headline)
                            .padding(.top)

                        ForEach(loggedActivities, id: \.self) { activity in
                            Text(activity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .foregroundColor(.primary)
                        }
                    }
                } else {
                    Text("No activities logged yet. Tap an icon to start!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        .onAppear(perform: fetchHealthData)
    }

    // MARK: - Activity Selection
    private func selectActivity(_ activity: String) {
        selectedActivity = activity
        elapsedTime = 0
        caloriesPerMinute = nil
    }

    // MARK: - Timer Logic
    private func toggleTimer() {
        timerActive.toggle()
        if timerActive {
            startTimer()
        } else {
            stopTimer()
        }
    }

    private func startTimer() {
        elapsedTime = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !timerActive {
                timer.invalidate()
                return
            }
            elapsedTime += 1

            // Update calories per minute dynamically
            if let activeEnergy = healthData["Active Energy"],
               let totalCalories = Double(activeEnergy.replacingOccurrences(of: " kcal", with: "")) {
                caloriesPerMinute = totalCalories / Double(elapsedTime / 60)
            }
        }
    }

    private func stopTimer() {
        saveActivityRecord()
    }

    // MARK: - Save Activity Record
    private func saveActivityRecord() {
        guard let activity = selectedActivity, let caloriesPerMinute = caloriesPerMinute else { return }
        let totalCalories = Int(caloriesPerMinute * Double(elapsedTime / 60))
        
        let activityRecord = ActivityRecord(
            activityName: activity,
            duration: elapsedTime,
            caloriesBurned: totalCalories,
            date: Date()
        )
        
        modelContext.insert(activityRecord)
        
        do {
            try modelContext.save()
            loggedActivities.append("\(activity): \(totalCalories) kcal in \(elapsedTime / 60)m")
        } catch {
            print("Failed to save activity: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Health Data
    private func fetchHealthData() {
        isLoading = true
        healthKitManager.requestAuthorization { success, error in
            if success {
                healthKitManager.fetchActiveEnergy { energy, error in
                    DispatchQueue.main.async {
                        if let energy = energy {
                            healthData["Active Energy"] = "\(Int(energy)) kcal"
                        }
                        isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    isLoading = false
                    print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

struct CalorieTrackProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieTrackProfileView()
            .previewLayout(.sizeThatFits)
    }
}
