import Foundation
struct OpenAIService {
    private let apiKey = "" // Замените на ваш API-ключ
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func getAdvice(prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo", // Используем новую модель
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 100
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error:", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            // Попробуем декодировать JSON-ответ и вывести его в отладку
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Received JSON response:", json ?? "No JSON structure")
                
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Unexpected JSON structure. JSON:", json ?? "nil")
                    completion(nil)
                }
            } catch {
                print("JSON decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
}
