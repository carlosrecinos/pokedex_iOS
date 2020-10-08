import Foundation
import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        let tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings_icon"), tag: 0)
        
        self.tabBarItem = tabBarItem
        self.tabBarController?.tabBar.tintColor = UIColor.pokeRed
        self.tabBarController?.tabBar.isTranslucent = true
    }
}
