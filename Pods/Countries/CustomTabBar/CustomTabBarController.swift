//
//  CustomTabBarController.swift
//  Countries
//
//  Created by Artem Dolbiev on 06.12.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 55
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    func loadTabBar() {
        let tabItems: [TabItem] = [.countries, .coordinates, .practice]
        
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0
    }
    
    private func setupCustomTabBar(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        self.customTabBar = TabNavigationMenu(menuItems: menuItems, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.itemTapped = self.changeTab
        var updatedSafeArea = UIEdgeInsets()
        updatedSafeArea.bottom = tabBarHeight
        self.additionalSafeAreaInsets = updatedSafeArea
        self.view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
        ])
        
        
        
        for i in 0 ..< menuItems.count {
            let navController = UINavigationController(rootViewController: menuItems[i].viewController)
            controllers.append(navController)
        }
        
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
        print("selected: \(self.selectedIndex) controller: \(self.viewControllers![self.selectedIndex])")
    }
}
