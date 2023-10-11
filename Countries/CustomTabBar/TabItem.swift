//
//  TabItem.swift
//  Countries
//
//  Created by Artem Dolbiev on 06.12.2021.
//

import UIKit

enum TabItem: String, CaseIterable {
    
case countries
case coordinates
case practice
    
    var viewController: UIViewController {
        switch self {
        case .countries: return CountriesTableView()
        case .coordinates: return CoordinatesVC()
        case .practice: return StartScreenVC()
        }
    }
    
    var icon: UIImage {
        switch self {
        case .countries: return UIImage(systemName: "globe.europe.africa.fill")!
        case .coordinates: return UIImage(systemName: "map")!
        case .practice: return UIImage(systemName: "gamecontroller.fill")!
        }
    }
    
    var displayTitle: String {
        switch self {
        case .coordinates:
            return String(localized: "Coordinates")
        case .countries:
            return String(localized: "Countries")
        case .practice:
            return String(localized: "Practice")
        }
    }
}
