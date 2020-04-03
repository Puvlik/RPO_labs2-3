import UIKit

final class FoodViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var tableViewData = [[String: String]]()
    private var counter = 0
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let alert = UIAlertController(title: "Wait please", message: nil, preferredStyle: .alert)
    private var isStart = true
    private let blackHelper = BlackModelHelper()
    
    // MARK: Constants

    private enum Constants {
        static let alertHeightConstraint: CGFloat = 95
        static let activityIndicatorCenterXConstraint: CGFloat = 0
        static let activityIndicatorBottomConstraint: CGFloat = -20
    }
    
    // MARK: Lyfecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: counter, food: "apple")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoadingScreen(start: isStart)
        isStart = false
    }
    
    // MARK: Methods

    func setLoadingScreen(start: Bool) {
        if start {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.isUserInteractionEnabled = false
            activityIndicator.color = blackHelper.checkColor()
            activityIndicator.startAnimating()

            alert.view.addSubview(activityIndicator)
            alert.view.heightAnchor.constraint(equalToConstant: Constants.alertHeightConstraint).isActive = true

            activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: Constants.activityIndicatorCenterXConstraint).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: Constants.activityIndicatorBottomConstraint).isActive = true
            present(alert, animated: true)
        } else {
            activityIndicator.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func getData(from: Int, food: String) {
        guard let id = Token.Food.app_id, let key = Token.Food.app_key else { return }
        NetworkingHelper.shared.requestMeals(type: .food, app_id: id, app_key: key, from: from, to: nil, food: food) { [weak self] result in
            guard let self = self else { return }
            if self.counter == 0 {
                self.tableViewData.removeAll()
            }
            guard let tableViewData = result as? [[String: String]] else { return }
            self.tableViewData += tableViewData
            DispatchQueue.main.async {
                self.setLoadingScreen(start: self.isStart)
                self.tableView.reloadData()
                self.title = food
            }
            self.counter += 1
            if self.counter != 5 {
                self.getData(from: self.counter, food: food)
            }
        }
    }
    
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        tableView.rowHeight = UITableView.automaticDimension
        cell.textLabel?.text = tableViewData[indexPath.row]["label"]
        return cell
    }
}

extension FoodViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        counter = 0
        getData(from: counter, food: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}
