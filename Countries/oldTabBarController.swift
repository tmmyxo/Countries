//
//  TabBarController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 30.09.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: CountriesTableView(), title: "Countries", image: UIImage(systemName: "globe.europe.africa.fill")!),
            createNavController(for: CoordinatesVC(), title: "Coordinates", image: UIImage(systemName: "map")!),
            createNavController(for: StartScreenVC(), title: "Practice", image: UIImage(systemName: "gamecontroller.fill")!)
        ]
    }

}
