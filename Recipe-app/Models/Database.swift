import UIKit

final class Database {
    static let shared = Database()
    private init() { }
    
    func getImage(stringUrl: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: stringUrl) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
    }
}
