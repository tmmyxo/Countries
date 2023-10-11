//
//  CustomTabBarController.swift
//  Countries
//
//  Created by Artem Dolbiev on 06.12.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {

    var customTabBar: TabNavigationMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
        self.changeNavigationBarAppearence()
    }

    private func changeNavigationBarAppearence() {
        let standardAppearence = UINavigationBarAppearance()
        standardAppearence.configureWithOpaqueBackground()
        standardAppearence.backgroundColor = Colors.secondaryBackground

        let scrollEdgeAppearence = UINavigationBarAppearance()
        scrollEdgeAppearence.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = standardAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearence
    }

    func loadTabBar() {
        let tabItems: [TabItem] = [.countries, .coordinates, .practice]
        self.setupCustomTabBar(tabItems)
        setViewControllers(for: tabItems)
        self.selectedIndex = 0
        self.tabBar.clipsToBounds = true
    }
    
    private func setupCustomTabBar(_ tabItems: [TabItem]) {
        let frame = tabBar.frame
        let tabNavigationMenu = TabNavigationMenu(tabItems: tabItems, frame: frame)
        tabNavigationMenu.translatesAutoresizingMaskIntoConstraints = false
        tabNavigationMenu.backgroundColor = Colors.secondaryBackground
        tabNavigationMenu.itemTapped = self.changeTab
        self.customTabBar = tabNavigationMenu

        self.view.addSubview(customTabBar)
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.customTabBar.topAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor),
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
        ])
    }

    private func setViewControllers(for tabItems: [TabItem]) {
        self.viewControllers = tabItems.map({ tabItem in
            return UINavigationController(rootViewController: tabItem.viewController)
        })
    }

    private func changeTab(tab: Int) {
        self.selectedIndex = tab
    }

    func hideTabMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.customTabBar.alpha = 0
        } completion: { _ in
            self.customTabBar.isHidden = true
        }
    }

    func showTabMenu() {
        self.customTabBar.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.customTabBar.alpha = 1
        }
    }
}
