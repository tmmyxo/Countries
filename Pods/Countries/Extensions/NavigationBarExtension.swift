//
//  NavigationBarExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.10.2021.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setOpaque() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        isTranslucent = false
    }
}
