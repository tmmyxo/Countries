//
//  FlagButton.swift
//  Countries
//
//  Created by Artem Dolbiiev on 05.09.2023.
//

import UIKit

class FlagButton: UIButton {

    private let generator = UIImpactFeedbackGenerator(style: .rigid)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.shadowColor = Colors.darkShadow.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRoundedImage(image: UIImage?) {
        let roundedImage = image?.withRoundedCorners(cornerRadius: 16)
        self.setImage(roundedImage, for: .normal)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        generator.impactOccurred(intensity: 0.7)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}

extension FlagButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.shadowColor = Colors.darkShadow.cgColor
    }
}
