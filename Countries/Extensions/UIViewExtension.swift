//
//  UIViewExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }

    func configureContactShadow() {
        let height = self.frame.height
        let width = self.frame.width
        let contactRect = CGRect(x: 0, y: height * 0.75, width: width, height: 10)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = Colors.darkShadow.cgColor
    }
}
