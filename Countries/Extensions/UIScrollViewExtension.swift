//
//  UIScrollViewExtension.swift
//  Countries
//
//  Created by Artem Dolbiiev on 05.09.2023.
//

import UIKit

extension UIScrollView {

    var fullContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }

    var visibleContentFrame: CGRect {
        bounds.inset(by: fullContentInsets)
    }
}
