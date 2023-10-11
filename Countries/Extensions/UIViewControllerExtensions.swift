//
//  UIViewControllerExtensions.swift
//  Countries
//
//  Created by Artem Dolbiiev on 03.09.2023.
//

import UIKit

extension UIViewController {

    func displayNotificationToUser(title: String, text: String, prefferedStyle: UIAlertController.Style, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: prefferedStyle)
        if let action = action {
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: action)
            alert.addAction(alertAction)
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
        }
        self.present(alert, animated: true)
    }

    func hideTabNavigationMenu() {
        guard let tabBarController = self.navigationController?.tabBarController as? CustomTabBarController else {
            return
        }
        tabBarController.hideTabMenu()
    }

    func showTabNavigationMenu() {
        guard let tabBarController = self.navigationController?.tabBarController as? CustomTabBarController else {
            return
        }
        tabBarController.showTabMenu()
    }
}
