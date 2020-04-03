import UIKit

final class SavedRecipesViewController: UIPageViewController {
    private var data = [[String: String]]()
    private let coreData = CoreDataHelper.shared
    
    // MARK: Lyfecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
    }
    
    // MARK: Methods

    func getViewController(for index: Int) -> MealViewController? {
        if index < 0 {
            return nil
        } else if index > data.count - 1 {
            return nil
        }
        let vc = R.storyboard.main.mealViewController()
        vc?.savedRecipes = data[index]
        return vc
    }
}

extension SavedRecipesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (pageViewController.viewControllers?.first?.view.tag ?? 0) - 1
        return getViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (pageViewController.viewControllers?.first?.view.tag ?? 0) + 1
        return getViewController(for: index)
    }

}
