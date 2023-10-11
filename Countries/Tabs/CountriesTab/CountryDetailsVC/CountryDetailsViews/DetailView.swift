//
//  DetailView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit

class DetailView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    init(title: String, text: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.textLabel.text = text
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(titleLabel, textLabel)
        backgroundColor = Colors.backgroundColor
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.shadowColor = Colors.darkShadow.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }
}

extension DetailView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = Colors.darkShadow.cgColor
    }
}
