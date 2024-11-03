//
//  NutriAIApp.swift
//  NutriAI
//
//  Created by Наталья Атюкова on 31.10.2024.
//

import SwiftUI
import SwiftData

@main
struct NutriAIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChatMessage.self,
            Profile.self, // Добавлена модель Profile
            MoodRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
