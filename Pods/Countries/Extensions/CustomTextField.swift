//
//  TextFieldExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.10.2021.
//

import UIKit

class TextField: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
