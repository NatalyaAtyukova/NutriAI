import UIKit
import Foundation
import Vision // Добавляем этот импорт для использования Vision API

struct FoodRecognitionService {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let recipeGenerationURL = "https://api.openai.com/v1/chat/completions" // URL для OpenAI рецептов (gpt-4-turbo)
    
    // Метод для распознавания объектов с помощью Vision API и получения информации о калориях
    func recognizeFoodWithVision(image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        let request = VNClassifyImageRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let results = request.results as? [VNClassificationObservation] {
                let recognizedFoods = results.filter { $0.confidence > 0.6 }.map { $0.identifier }
                completion(.success(recognizedFoods))
            } else {
                completion(.failure(NSError(domain: "No food recognized", code: -3, userInfo: nil)))
            }
        }
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    // Метод для генерации рецепта на основе ингредиентов с использованием gpt-4-turbo
    func generateRecipe(ingredients: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: recipeGenerationURL) else {
            print("Invalid URL.")
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "Create a recipe with these ingredients: \(ingredients.joined(separator: ", "))"
        let parameters: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 300,
            "temperature": 0.7
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Received JSON response:", json ?? "No JSON structure")
                
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(NSError(domain: "Unexpected JSON structure", code: -3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Вспомогательная функция для создания тела запроса `multipart/form-data`
    private func createMultipartBody(data: Data, boundary: String, fieldName: String, fileName: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
