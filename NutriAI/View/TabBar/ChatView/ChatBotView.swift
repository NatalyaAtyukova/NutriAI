import SwiftUI
import SwiftData

struct ChatBotView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.date, order: .forward) private var chatHistory: [ChatMessage] // Указан тип ChatMessage

    @State private var userInput: String = ""
    @State private var isLoading: Bool = false
    @State private var requestLimitReached: Bool = false
    
    private let maxRequestsPerDay = 5
    
    // Примеры вопросов для пользователя
    private let exampleQuestions = [
        "Рацион для похудения?",
        "Продукты с белком?",
        "Идеи для завтрака",
        "Как меньше сахара?",
        "Продукты для пищеварения"
    ]
    
    var body: some View {
        VStack {
            Text("Chat with NutriAI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(chatHistory) { chatMessage in
                            ChatCard(message: chatMessage.message, isUserMessage: chatMessage.isUserMessage)
                        }
                    }
                    .padding()
                    .onChange(of: chatHistory.count) { _ in
                        // Прокручиваем к последнему сообщению при добавлении нового
                        if let lastMessage = chatHistory.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            if requestLimitReached {
                Text("You have reached your daily limit of 5 requests.")
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Компактные предложения прямо над полем ввода
                HStack {
                    Text("Попробуйте: ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(exampleQuestions, id: \.self) { question in
                                Button(action: {
                                    sendExampleQuestion(question)
                                }) {
                                    Text(question)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                HStack {
                    TextField("Ask me anything about nutrition...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: sendMessage) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Send")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(userInput.isEmpty || isLoading)
                }
                .padding()
            }
        }
        .onAppear {
            checkDailyRequestLimit()
        }
    }
    
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        
        // Проверка на превышение лимита
        if !incrementDailyRequestCount() {
            requestLimitReached = true
            return
        }
        
        let prompt = userInput
        addMessageToChatHistory(message: prompt, isUserMessage: true) // Сохраняем запрос пользователя
        isLoading = true
        userInput = ""
        
        OpenAIService().getAdvice(prompt: prompt) { response in
            DispatchQueue.main.async {
                if let response = response {
                    addMessageToChatHistory(message: response, isUserMessage: false) // Ответ от чат-бота
                } else {
                    addMessageToChatHistory(message: "NutriAI: Sorry, I couldn't process your question.", isUserMessage: false)
                }
                isLoading = false
            }
        }
    }
    
    // Функция для добавления сообщения в SwiftData
    private func addMessageToChatHistory(message: String, isUserMessage: Bool) {
        let newMessage = ChatMessage(message: message, isUserMessage: isUserMessage)
        modelContext.insert(newMessage)
        
        do {
            try modelContext.save() // Сохранение данных
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }
    
    // Функция для отправки примерного вопроса
    private func sendExampleQuestion(_ question: String) {
        userInput = question
        sendMessage()
    }
    
    // Проверка ежедневного лимита
    private func checkDailyRequestLimit() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastRequestResetDate") as? Date ?? Date.distantPast
        if !Calendar.current.isDateInToday(lastResetDate) {
            // Сброс счетчика, если сегодня еще не делали сброс
            UserDefaults.standard.set(Date(), forKey: "lastRequestResetDate")
            UserDefaults.standard.set(0, forKey: "dailyRequestCount")
        }
        
        // Проверяем, достигнут ли лимит
        let currentRequestCount = UserDefaults.standard.integer(forKey: "dailyRequestCount")
        requestLimitReached = currentRequestCount >= maxRequestsPerDay
    }
    
    // Увеличение количества запросов и проверка лимита
    private func incrementDailyRequestCount() -> Bool {
        let currentRequestCount = UserDefaults.standard.integer(forKey: "dailyRequestCount")
        
        if currentRequestCount < maxRequestsPerDay {
            UserDefaults.standard.set(currentRequestCount + 1, forKey: "dailyRequestCount")
            return true
        }
        
        return false
    }
}

#Preview {
    ChatBotView()
}
