Ты абсолютно права! Исправим описание для соответствия использованию SwiftData вместо CoreData. Вот обновленный README.md:

NutriAI 🍎💪

NutriAI is an innovative iOS application designed to help users track their calories, monitor activities, and achieve their fitness goals with ease. Built with Swift and leveraging SwiftData, SwiftUI, and HealthKit, NutriAI integrates cutting-edge AI-powered insights into your daily nutrition and fitness routines.

Features 🚀

1. Daily Calorie Intake Tracking

	•	Visualize your daily calorie consumption.
	•	Track macronutrient distribution: protein, carbs, and fats.
	•	Get personalized recommendations to maintain a balanced diet.

2. Activity Tracking

	•	Select activities like walking, running, cycling, and more.
	•	Start and stop activity sessions with a built-in timer.
	•	Dynamically calculate calories burned per minute based on activity type and duration.
	•	Save activity records, including duration, calories burned, and session history.

3. Integration with HealthKit

	•	Sync with HealthKit to retrieve:
	•	Active energy burned.
	•	Steps taken.
	•	Exercise minutes.
	•	Sleep analysis.
	•	Display real-time health data from Apple Watch and other devices.

4. Personalized Meal Plans

	•	Generate AI-powered meal plans based on your preferences and dietary goals.
	•	Explore different nutrition categories like balanced diets, plant-based options, and more.

5. Goals Setting

	•	Set and customize daily calorie goals.
	•	Monitor progress against your targets.

Installation 🛠️

	1.	Clone the repository:

git clone https://github.com/your-repo/nutriai.git


	2.	Open the project in Xcode:

cd nutriai
open NutriAI.xcodeproj


	3.	Set up your Apple Developer credentials to enable HealthKit features.
	4.	Run the app on your iOS simulator or device.

Requirements 📋

	•	iOS 17.0+
	•	Xcode 15+
	•	Swift 5.9+
	•	Apple Developer account (for HealthKit integration)

Technologies Used 🔧

	•	SwiftUI: Intuitive and declarative UI framework.
	•	SwiftData: Simplified persistence framework for storing activity and meal tracking records.
	•	HealthKit: Integration with Apple Health for real-time fitness and health data.
	•	AI Integration: OpenAI API for meal plan generation and dietary insights.

Contributing 🤝

We welcome contributions! Here’s how you can help:
	1.	Fork the repository.
	2.	Create a feature branch:

git checkout -b feature/your-feature


	3.	Commit your changes:

git commit -m "Add your feature"


	4.	Push to your branch:

git push origin feature/your-feature


	5.	Submit a pull request.
