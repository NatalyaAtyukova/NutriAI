import Foundation
import UIKit
import Vision
import CoreML

class FoodRecognitionService: ObservableObject {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let calorieEstimationURL = "https://api.openai.com/v1/chat/completions"
    
    private lazy var foodModel: VNCoreMLModel? = {
        do {
            let model = try FoodClassifier(configuration: MLModelConfiguration())
            print("Модель FoodClassifier успешно загружена")
            return try VNCoreMLModel(for: model.model)
        } catch {
            print("Ошибка загрузки модели FoodClassifier: \(error)")
            return nil
        }
    }()
    
    private lazy var fruitModel: VNCoreMLModel? = {
        do {
            let model = try FruitsClassifier(configuration: MLModelConfiguration())
            print("Модель FruitsClassifier успешно загружена")
            return try VNCoreMLModel(for: model.model)
        } catch {
            print("Ошибка загрузки модели FruitsClassifier: \(error)")
            return nil
        }
    }()
    
    private lazy var vegetableModel: VNCoreMLModel? = {
        do {
            let model = try VegetableClassifier(configuration: MLModelConfiguration())
            print("Модель VegetableClassifier успешно загружена")
            return try VNCoreMLModel(for: model.model)
        } catch {
            print("Ошибка загрузки модели VegetableClassifier: \(error)")
            return nil
        }
    }()
    
    func recognizeAllCategories(image: UIImage, completion: @escaping (Result<[String: [String]], Error>) -> Void) {
        guard let foodModel = foodModel, let fruitModel = fruitModel, let vegetableModel = vegetableModel else {
            completion(.failure(NSError(domain: "Models not loaded", code: -1, userInfo: nil)))
            return
        }
        
        var resultsDict: [String: [String]] = ["Food": [], "Fruit": [], "Vegetable": []]
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        recognize(image: image, with: foodModel) { result in
            switch result {
            case .success(let foods):
                resultsDict["Food"] = foods
            case .failure(let error):
                print("Ошибка распознавания еды: \(error)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        recognize(image: image, with: fruitModel) { result in
            switch result {
            case .success(let fruits):
                resultsDict["Fruit"] = fruits
            case .failure(let error):
                print("Ошибка распознавания фруктов: \(error)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        recognize(image: image, with: vegetableModel) { result in
            switch result {
            case .success(let vegetables):
                resultsDict["Vegetable"] = vegetables
            case .failure(let error):
                print("Ошибка распознавания овощей: \(error)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(resultsDict))
        }
    }
    
    private func recognize(image: UIImage, with model: VNCoreMLModel, completion: @escaping (Result<[String], Error>) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let results = request.results as? [VNClassificationObservation] {
                let recognizedItems = results.filter { $0.confidence > 0.6 }.map { $0.identifier }
                completion(.success(recognizedItems))
            } else {
                completion(.failure(NSError(domain: "No items recognized", code: -3, userInfo: nil)))
            }
        }
        
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "Invalid image", code: -4, userInfo: nil)))
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    func estimateCalories(ingredients: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard !ingredients.isEmpty else {
            completion(.success("0"))
            return
        }
        
        guard let url = URL(string: calorieEstimationURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "Estimate total calories for the following ingredients: \(ingredients.joined(separator: ", "))"
        let parameters: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 100,
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
                
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    print("OpenAI response: \(content)") // Логирование ответа
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(NSError(domain: "Unexpected JSON structure", code: -3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func generateDailyMealPlan(for category: String, completion: @escaping (Result<[String], Error>) -> Void) {
            guard let url = URL(string: calorieEstimationURL) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let prompt = """
            Create a detailed one-day meal plan for a \(category) diet. Include breakfast, lunch, snack, and dinner. Format:
            - Breakfast: ...
            - Lunch: ...
            - Snack: ...
            - Dinner: ...
            """
            let parameters: [String: Any] = [
                "model": "gpt-4-turbo",
                "messages": [["role": "user", "content": prompt]],
                "max_tokens": 200,
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
                    
                    if let choices = json?["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        let meals = content
                            .components(separatedBy: "\n")
                            .filter { !$0.isEmpty }
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        completion(.success(meals))
                    } else {
                        completion(.failure(NSError(domain: "Unexpected JSON structure", code: -3, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}
