import UIKit

final class SavedMealsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var data = [[String: String]]()
    private let coreData = CoreDataHelper.shared
    
    // MARK: Lyfecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        coreData.getData { [weak self] error, result in
            guard let self = self else { return }
            if let result = result, error == nil {
                self.data = result
                self.tableView.reloadData()
            }
            else if let error = error {
                print("error: \(error)")
            }
        }
    }
    
    // MARK: Actions
 
    @IBAction func pushCreateMeal(_ sender: UIButton) {
        
    }
    
    // MARK: Methods

}

extension SavedMealsViewController: UITableViewDelegate {
    
}

extension SavedMealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMeals", for: indexPath)
        cell.textLabel?.text = " \(data[indexPath.row]["label"] ?? "") \n \(data[indexPath.row]["time"] ?? "") \n \(data[indexPath.row]["weight"] ?? "")"
        Database.shared.getImage(stringUrl: data[indexPath.row]["image"] ?? "") { image in
            cell.imageView?.image = image
            tableView.reloadData()
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
