//
//  UIColors.swift
//  Countries
//
//  Created by Artem Dolbiiev on 28.09.2023.
//

import UIKit

struct Colors {

    static let backgroundColor: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.13, green: 0.15, blue: 0.16, alpha: 1.00)
            case .light:
                return UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
            case .unspecified:
                return UIColor.systemBackground
            }
        }
    }()

    static let secondaryBackground: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.11, green: 0.13, blue: 0.13, alpha: 1.00)
            case .light:
                return UIColor(red: 0.92, green: 0.92, blue: 0.91, alpha: 1.00)
            case .unspecified:
                return UIColor.secondarySystemBackground
            }
        }
    }()

    static let label: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            case .light:
                return backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let labelLight: UIColor = {
        return label.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    }()

    static let labelDark: UIColor = {
        return label.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
    }()

    static let labelFlipped: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            case .light:
                return backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let detailRed: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.88, green: 0.28, blue: 0.29, alpha: 1.00)
            case .light:
                return UIColor(red: 0.98, green: 0.29, blue: 0.31, alpha: 1.00)
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let detailOrange: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 1.00, green: 0.38, blue: 0.28, alpha: 1.00)
            case .light:
                return UIColor(red: 1.00, green: 0.43, blue: 0.35, alpha: 1.00)
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let detailMint: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.15, green: 0.59, blue: 0.46, alpha: 1.00)
            case .light:
                return UIColor(red: 0.14, green: 0.74, blue: 0.56, alpha: 1.00)
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let detailBlue: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.02, green: 0.55, blue: 0.86, alpha: 1.00)
            case .light:
                return UIColor(red: 0.00, green: 0.61, blue: 0.96, alpha: 1.00)
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let lightShadow: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.06)
            case .light:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case .unspecified:
                return UIColor.label
            }
        }
    }()

    static let darkShadow: UIColor = {
        UIColor.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.50)
            case .light:
                return UIColor(red: 0.63, green: 0.63, blue: 0.57, alpha: 0.70)
            case .unspecified:
                return UIColor.label
            }
        }
    }()
}
