import UIKit

final class MealsCollectionViewController: UICollectionViewController {
    weak var delegate: ShareMealsDelegate?
    private var result = [[String: Any]]()
    private var duration = (from: 0, to: 8)
    private var counter = 5
    private var previousSearch = "beef"
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let alert = UIAlertController(title: "Wait please", message: nil, preferredStyle: .alert)
    private var isStart = true
    private let networking = NetworkingHelper.shared
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
        addInfo(type: .recipe, food: previousSearch)
        title = previousSearch
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "reloadDataWithoutScroll"), object: nil, queue: nil) {_ in
            print(self.result)
            self.collectionView.reloadDataWithoutScroll()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLoadingScreen(start: isStart)
        isStart = false
    }
    
    // MARK: Actions
    
    @IBAction func pushSearch(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Search your meal", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter your meal"
        }
        let actionfirst = UIAlertAction(title: "search", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if let text = alert.textFields?.first?.text {
                if !text.isEmpty {
                    self.previousSearch = text
                }
            }
            self.counter = 5
            self.duration = (from: 0, to: 8)
            self.title = self.previousSearch
            self.addInfo(type: .recipe, food: self.previousSearch)
        })
        actionfirst.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        alert.addAction(actionfirst)
        let actionSecond = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        actionSecond.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        alert.addAction(actionSecond)
        present(alert, animated: true)
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
            alert.dismiss(animated: true)
        }
    }
    
    func addInfo(type: RequestType, food: String) {
            guard let id = Token.Recipe.app_id, let key = Token.Recipe.app_key else { return }
            networking.requestMeals(type: type, app_id: id, app_key: key, from: duration.from, to: duration.to, food: food) { [weak self] result in
                guard let self = self else { return }
                if self.counter == 5 {
                    self.result.removeAll()
                }
                self.counter -= 1
                self.result += result
                DispatchQueue.main.async {
                    self.collectionView.reloadDataWithoutScroll()
                    self.setLoadingScreen(start: self.isStart)
                }
                if self.counter > 0 {
                    self.addInfo(type: type, food: food)
                }
            }
            duration.from = duration.to + 1
            duration.to += 8
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealsCell", for: indexPath) as? MealsCell else { return UICollectionViewCell() }
        if let image = result[indexPath.row]["image"] as? UIImage {
            cell.imageView.image = image
        }
        cell.label.text = result[indexPath.row]["label"] as? String
        let frameSize = collectionView.frame.width / 2 - 30
        cell.height.constant = frameSize
        cell.width.constant = frameSize
        return cell
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = R.storyboard.main.mealViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        delegate = vc
        delegate?.shareData(dictionary: result[indexPath.row])
    }
    
}
