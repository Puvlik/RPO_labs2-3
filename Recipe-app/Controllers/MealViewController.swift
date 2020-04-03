import UIKit

final class MealViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var weight: UILabel!
    @IBOutlet private weak var calories: UILabel!
    private var stringImage: String?
    private var ingredients = [(hours: String, minutes: String)]()
    private let database = Database.shared
    var savedRecipes: [String: String]?
    private let coreData = CoreDataHelper.shared

    // MARK: Constants
    
    private enum Constants {
        static let notificationViewWidth: CGFloat = 180
        static let notificationViewHeight: CGFloat = 100
        static let notificationFadeOutDuartion: Double = 2
        static let notificationFadeOutDelay: Double = 0.8
    }
    
    // MARK: Actions
    
    @IBAction func pushBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func pushAdd(_ sender: UIBarButtonItem) {
        let dict = [
            "image": stringImage ?? "",
            "label": navBar.topItem?.title ?? "",
            "time": time.text ?? "",
            "weight": weight.text ?? "",
            "calories": calories.text ?? ""
        ]
        coreData.saveData(data: dict)
        
        let notificationView = NotificationView()
        notificationView.frame = CGRect(x: view.bounds.midX - 90, y: view.bounds.midY - 50, width: Constants.notificationViewWidth, height: Constants.notificationViewHeight)
        view.addSubview(notificationView)
        notificationView.alpha = 0
        notificationView.fadeIn { _ in
            sender.isEnabled = false
        }
        notificationView.fadeOut(duration: Constants.notificationFadeOutDuartion, delay: Constants.notificationFadeOutDelay, completion: { _ in
            notificationView.removeFromSuperview()
            sender.isEnabled = true
        })
    }
    
}

extension MealViewController: ShareMealsDelegate {
    func shareData(dictionary: [String : Any]) {
        if let image = dictionary["image"] as? UIImage {
            imageView.image = image
        }
        if let strImage = dictionary["stringImage"] as? String {
            stringImage = strImage
        }
        navBar.topItem?.title = dictionary["label"] as? String
        let fullTime = (dictionary["time"] as? (mins: Int, hours: Int)) ?? (0, 0)
        if fullTime.mins == 0 && fullTime.hours == 0 {
            time.text = "Cooking time: several minutes"
        } else if fullTime.mins == 0 {
            time.text = "Cooking time: \(fullTime.hours) min"
        } else if fullTime.hours == 0 {
            time.text = "Cooking time: \(fullTime.mins) h"
        } else {
            time.text = "Cooking time: \(fullTime.mins) h \(fullTime.hours) min"
        }
        weight.text = "Weight: \(dictionary["weight"] ?? "") gr"
        calories.text = "Calories: \(dictionary["calories"] ?? "") kcal"
        ingredients = dictionary["ingredients"] as? [(String, String)] ?? [("", "")]
    }
}

extension MealViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        tableView.rowHeight = UITableView.automaticDimension
        cell.textLabel?.text = "\(ingredients[indexPath.row].hours) - \(ingredients[indexPath.row].minutes) gr"
        return cell
    }
}
