//
//  CustomLabel.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 04.11.2021.
//

import UIKit

class LabelWithPadding: UILabel {
    
    var contentInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }

    func getSize(for text: String, inside frame: CGRect, padding: CGSize = CGSize.zero) -> CGSize {
        let sizeOfText = self.calculateSize(for: text, inside: frame, padding: padding)
        let sizeWithInsets = addInsets(to: sizeOfText)
        return sizeWithInsets
    }
}
