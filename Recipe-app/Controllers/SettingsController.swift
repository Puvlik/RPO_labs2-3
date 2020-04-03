import Foundation
import UIKit

final class SettingsController: UIViewController {
    
    // MARK: Lyfecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: Actions

    @IBAction func pushChangeRecipeKey() {
        Token.Recipe.newKey()
    }
    
    @IBAction func pushChangeFoodKey() {
        Token.Food.newKey()
    }
}
