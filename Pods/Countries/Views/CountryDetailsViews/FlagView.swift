//
//  FlagView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.09.2021.
//

import UIKit

class FlagView: UIView {
    
    private lazy var flagImageView: UIImageView = {
        let flag = UIImageView()
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.contentMode = .scaleAspectFit
        return flag
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    public convenience init(flagImage: UIImage) {
        self.init(frame: .zero)
        self.flagImageView.image = flagImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(flagImageView)
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 7
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            flagImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
