//
//  UIStackViewExtension.swift
//  Countries
//
//  Created by Artem Dolbiiev on 03.10.2023.
//

import UIKit.UIStackView

extension UIStackView {

    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}
