//
//  NeumorphicButton.swift
//  Countries
//
//  Created by Artem Dolbiiev on 28.09.2023.
//



import UIKit

class NeumorphicView: UIView {

    lazy var darkShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize(width: 5, height: 5)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowColor = Colors.darkShadow.withAlphaComponent(0.1).cgColor
        shadowLayer.backgroundColor = Colors.secondaryBackground.cgColor
        return shadowLayer
    }()

    lazy var lightShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize(width: -5, height: -5)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowColor = Colors.lightShadow.cgColor
        shadowLayer.backgroundColor = Colors.secondaryBackground.cgColor
        return shadowLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        lightShadow.frame = self.bounds
        darkShadow.frame = self.bounds
        lightShadow.cornerRadius = self.layer.cornerRadius
        darkShadow.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(lightShadow, at: 0)
        self.layer.insertSublayer(darkShadow, at: 0)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateShadowColors()
    }

    func updateShadowColors() {
        lightShadow.backgroundColor = Colors.lightShadow.cgColor
        lightShadow.shadowColor = Colors.lightShadow.cgColor

        darkShadow.backgroundColor = Colors.darkShadow.cgColor
        darkShadow.shadowColor = Colors.darkShadow.cgColor
    }
}
