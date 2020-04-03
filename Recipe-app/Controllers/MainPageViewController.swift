import UIKit

class MainPageViewController: UIViewController {

    // MARK: Lyfecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Actions

    @IBAction func pushRecipes() {
        guard let vc = R.storyboard.main.mealsCollectionViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushFood() {
        guard let vc = R.storyboard.main.foodViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushMyFood() {
        guard let vc = R.storyboard.main.savedTabBarController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
