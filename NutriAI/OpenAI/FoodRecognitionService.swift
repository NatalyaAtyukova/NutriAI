import Foundation
import UIKit
import Vision
import CoreML

class FoodRecognitionService: ObservableObject {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let calorieEstimationURL = "https://api.openai.com/v1/chat/completions"
    
    private var foodModel: VNCoreMLModel?
    private var fruitModel: VNCoreMLModel?
    private var vegetableModel: VNCoreMLModel?
    
    init() {
        // Загрузка моделей
        do {
            let foodClassifierModel = try FoodClassifier(configuration: MLModelConfiguration())
            foodModel = try VNCoreMLModel(for: foodClassifierModel.model)
            print("Модель FoodClassifier успешно загружена")
            
            let fruitClassifierModel = try FruitsClassifier(configuration: MLModelConfiguration())
            fruitModel = try VNCoreMLModel(for: fruitClassifierModel.model)
            print("Модель FruitsClassifier успешно загружена")
            
            let vegetableClassifierModel = try VegetableClassifier(configuration: MLModelConfiguration())
            vegetableModel = try VNCoreMLModel(for: vegetableClassifierModel.model)
            print("Модель VegetableClassifier успешно загружена")
        } catch {
            print("Ошибка загрузки моделей: \(error)")
        }
    }
    
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
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(NSError(domain: "Unexpected JSON structure", code: -3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
