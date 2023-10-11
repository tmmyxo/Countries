//
//  TabBarSearchButton.swift
//  Countries
//
//  Created by Artem Dolbiiev on 12.09.2023.
//

import UIKit

class CustomTabBarSearchButton: UIButton {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        generator.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        generator.impactOccurred()
        animateTouchedButton()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        generator.impactOccurred(intensity: 0.5)
        animateReleasedButton()
    }

    private func animateTouchedButton() {
        UIView.animate(withDuration: 0.05) {
            self.isHighlighted = true
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.layer.shadowColor = UIColor.systemMint.cgColor
            self.layer.shadowRadius = 15
            self.layer.shadowOpacity = 0.7
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }

    private func animateReleasedButton() {
        UIView.animate(withDuration: 0.05) {
            self.isHighlighted = false
            self.transform = .identity
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
        }
    }
}
