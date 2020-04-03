import UIKit
import Foundation
import Alamofire

final class NetworkingHelper {
    static let shared = NetworkingHelper()
    private init() {}

    func createUrl(host: String, path: String, q: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = q
        
        if (urlComponents.url == nil) {
            return URL(string: "")
        }
        guard let url = urlComponents.url else { return URL(string: "")}
        return URL(string: url.absoluteString)
    }
    
    func requestMeals(type: RequestType, app_id: String, app_key: String, from: Int?, to: Int?, food: String, completion f: @escaping ([[String: Any]]) -> ()) {
        if type == .recipe {
            guard let from = from, let to = to else { return }
            let url = createUrl(
                host: "api.edamam.com",
                path:  "/search",
                q: [
                    URLQueryItem(name: "q", value: food),
                    URLQueryItem(name: "app_id", value: app_id),
                    URLQueryItem(name: "from", value: "\(from)"),
                    URLQueryItem(name: "to", value: "\(to)"),
                    URLQueryItem(name: "app_key", value: app_key)
                ]
            )
            guard let newUrl = url else { return }
            AF.request(newUrl).validate().responseDecodable(of: Meal.self) {response in
                guard let hits = response.value?.hits else { return }
                var values = [[String: Any]]()
                for elem in hits {
                    var dict = [String: Any]()
                    var ingredients = [(text: String, weight: String)]()
                    for ingredient in elem.recipe.ingredients {
                        ingredients.append((text: ingredient.text, weight: "\(Int(ingredient.weight))"))
                    }
                    dict["label"] = elem.recipe.label
                    
                    guard let url = URL(string: elem.recipe.image) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    dict["image"] = UIImage(data: data)
                    
                    dict["stringImage"] = elem.recipe.image
                    dict["time"] = (hours: Int(elem.recipe.totalTime) / 60, minutes: (Int(elem.recipe.totalTime) % 60))
                    dict["weight"] = Int(elem.recipe.totalWeight)
                    dict["ingredients"] = ingredients
                    dict["calories"] = Int(elem.recipe.calories)
                    
                    values.append(dict)
                }
                f(values)
            }
        } else if type == .food {
            let url = createUrl(
                host: "api.edamam.com",
                path:  "/api/food-database/parser",
                q: [
                    URLQueryItem(name: "ingr", value: food),
                    URLQueryItem(name: "app_id", value: app_id),
                    URLQueryItem(name: "app_key", value: app_key),
                    URLQueryItem(name: "page", value: "\(from ?? 0)")
                ]
            )
            guard let newUrl = url else { return }
            let task = URLSession.shared.dataTask(with: newUrl) { data, responce, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(FoodVariety.self, from: data)
                        guard let hints = res.hints else { return }
                        var values = [[String: String]]()
                        for elem in hints {
                            var dict = [String: String]()
                            dict["label"] = elem.food.label
                            if let kcal = elem.food.nutrients.ENERC_KCAL {
                                dict["kcal"] = "\(round((kcal) * 10) / 10)"
                            }
                            if let proteins = elem.food.nutrients.PROCNT {
                                dict["proteins"] = "\(round((proteins) * 10) / 10)"
                            }
                            if let fats = elem.food.nutrients.FAT {
                                dict["fat"] = "\(round((fats) * 10) / 10)"
                            }
                            if let carbs = elem.food.nutrients.CHOCDF {
                                dict["carbs"] = "\(round((carbs) * 10) / 10)"
                            }
                            values.append(dict)
                        }
                        f(values)
                    } catch {
                        print(error)
                        return
                    }
                }
            }
            task.resume()
        }
    }
}
