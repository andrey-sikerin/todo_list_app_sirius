import Foundation
import UIKit

class RootGraph {
    private(set) var rootViewController: UIViewController

    init() {
        let editTaskViewController = EditTaskViewController(
                strings: EditTaskViewController.Strings(
                        leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
                        rightNavigationBarText: NSLocalizedString("Save", comment: ""),
                        titleNavigationBarText: NSLocalizedString("Task", comment: ""),
                        textViewPlaceholder: NSLocalizedString("TaskDescriptionPlaceholder", comment: ""),
                        buttonText: NSLocalizedString("Delete", comment: "")
                ),
                styles: EditTaskViewController.Styles(
                        itemsBorderRadius: AppStyles.borderRadius,
                        itemsBackgroundColor: .white,
                        backgroundColor: .lightGray,
                        textSize: 17,
                        textViewTextColor: .black,
                        textViewPlaceholderColor: .gray,
                        buttonTextColor: .gray,
                        buttonPressedTextColor: .black,
                        buttonHeight: 56
                )
        )
        let navigationController = UINavigationController(rootViewController: editTaskViewController)
        rootViewController = navigationController
    }
}
