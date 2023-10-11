//
//  RightCalloutView.swift
//  Countries
//
//  Created by Artem Dolbiev on 15.11.2021.
//

import UIKit

class RightCalloutView: UIButton{
    
//    var savePointButton: UIButton = {
//        var button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
//        button.tintColor = .white
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    func setupView() {
//        self.addSubview(savePointButton)
//        backgroundColor = .systemBlue
//
//        NSLayoutConstraint.activate([
////            self.heightAnchor.constraint(equalToConstant: 100),
////            self.widthAnchor.constraint(equalToConstant: 60),
//            savePointButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            savePointButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            savePointButton.heightAnchor.constraint(equalTo: self.heightAnchor),
//            savePointButton.widthAnchor.constraint(equalTo: self.widthAnchor)
//        ])
//    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        self.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        self.tintColor = .white
        self.backgroundColor = .systemBlue
    }
    
}
