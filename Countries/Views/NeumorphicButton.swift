//
//  NeumorphicButton.swift
//  Countries
//
//  Created by Artem Dolbiiev on 29.09.2023.
//

import UIKit

class NeumorphicButton: UIButton {

    lazy var generator = UIImpactFeedbackGenerator(style: .rigid)

    private var lightShadowOffset = CGSize(width: -5, height: -5)
    private var darkShadowOffset = CGSize(width: 5, height: 5)

    lazy var outerDarkShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize(width: 5, height: 5)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 8
        shadowLayer.shadowColor = Colors.darkShadow.cgColor
        return shadowLayer
    }()

    lazy var outerLightShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize(width: -5, height: -5)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 8
        shadowLayer.shadowColor = Colors.lightShadow.cgColor
        return shadowLayer
    }()

    lazy var innerDarkShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowColor = Colors.darkShadow.cgColor
        shadowLayer.shadowOpacity = 0
        shadowLayer.masksToBounds = true
        return shadowLayer
    }()

    lazy var innerLightShadow: CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowColor = Colors.lightShadow.cgColor
        shadowLayer.shadowOpacity = 0
        shadowLayer.masksToBounds = true
        return shadowLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.insertSublayer(outerLightShadow, at: 0)
        self.layer.insertSublayer(outerDarkShadow, at: 0)
        self.layer.addSublayer(innerDarkShadow)
        self.layer.addSublayer(innerLightShadow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerDarkShadow.backgroundColor = self.backgroundColor?.cgColor
        outerLightShadow.backgroundColor = self.backgroundColor?.cgColor
        outerLightShadow.frame = self.bounds
        outerLightShadow.cornerRadius = self.layer.cornerRadius

        outerDarkShadow.frame = self.bounds
        outerDarkShadow.cornerRadius = self.layer.cornerRadius

        innerLightShadow.frame = self.bounds
        innerLightShadow.cornerRadius = self.layer.cornerRadius

        innerDarkShadow.frame = self.bounds
        innerDarkShadow.cornerRadius = self.layer.cornerRadius

        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -5, dy: -5), cornerRadius: 28)
        let cutout = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).reversing()
        path.append(cutout)
        innerDarkShadow.shadowPath = path.cgPath
        innerLightShadow.shadowPath = path.cgPath

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateShadowColors()
    }

    func updateShadowColors() {
        outerLightShadow.backgroundColor = self.backgroundColor?.cgColor
        outerLightShadow.shadowColor = Colors.lightShadow.cgColor

        outerDarkShadow.backgroundColor = self.backgroundColor?.cgColor
        outerDarkShadow.shadowColor = Colors.darkShadow.cgColor

        innerLightShadow.shadowColor = Colors.lightShadow.cgColor
        innerDarkShadow.shadowColor = Colors.darkShadow.cgColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.layer.masksToBounds = true
        generator.impactOccurred(intensity: 1.0)
        UIView.animateKeyframes(withDuration: 0.2, delay: 0) {
            self.titleLabel?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                self.outerLightShadow.shadowOffset = CGSize.zero
                self.outerDarkShadow.shadowOffset = CGSize.zero
            }
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                self.outerLightShadow.shadowOpacity = 0
                self.outerDarkShadow.shadowOpacity = 0
                self.innerDarkShadow.shadowOpacity = 1
                self.innerLightShadow.shadowOpacity = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.innerDarkShadow.shadowOffset = self.darkShadowOffset
                self.innerLightShadow.shadowOffset = self.lightShadowOffset
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        generator.impactOccurred(intensity: 0.6)
        self.layer.masksToBounds = false
        UIView.animateKeyframes(withDuration: 0.2, delay: 0) {
            self.titleLabel?.transform = .identity
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                self.innerDarkShadow.shadowOffset = CGSize.zero
                self.innerLightShadow.shadowOffset = CGSize.zero
            }
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                self.innerDarkShadow.shadowOpacity = 0
                self.innerLightShadow.shadowOpacity = 0
                self.outerLightShadow.shadowOpacity = 1
                self.outerDarkShadow.shadowOpacity = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.outerLightShadow.shadowOffset = self.lightShadowOffset
                self.outerDarkShadow.shadowOffset = self.darkShadowOffset
            }
        }
    }
}
