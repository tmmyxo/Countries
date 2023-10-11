//
//  UILabelExtension.swift
//  Countries
//
//  Created by Artem Dolbiiev on 15.09.2023.
//

import UIKit.UILabel

extension UILabel {

    func calculateSize(for text: String, inside frame: CGRect, padding: CGSize = CGSize.zero) -> CGSize{
        let textString = NSAttributedString(string: text, attributes: [.font : self.font as Any])
        let size = CGSize(width: frame.width - padding.width, height: frame.height - padding.height)
        let rect = textString.boundingRect(with: size, options: [.usesDeviceMetrics, .usesFontLeading, .usesLineFragmentOrigin], context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }

    func fadeInLeftToRight(duration: Double){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: -1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        let animation = CABasicAnimation(keyPath: "startPoint")
        animation.fromValue = gradientLayer.startPoint
        animation.toValue = gradientLayer.endPoint
        animation.duration = duration
        animation.delegate = self

        gradientLayer.add(animation, forKey: "startPoint")
        layer.mask = gradientLayer
    }

    func setParagraphSpacing(_ spacing: CGFloat) {
        guard let text = self.text else {
            return
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        paragraphStyle.alignment = textAlignment

        let attributedString: NSMutableAttributedString

        if let attributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text)
        }

        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}

extension UILabel: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.mask = nil
    }
}
