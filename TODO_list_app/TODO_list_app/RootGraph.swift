import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UIViewController
    
    init() {
        let viewController = EditTaskViewController()
        let navigationController = NavigationController(rootViewController: viewController)
        rootViewController = navigationController
    }
}
