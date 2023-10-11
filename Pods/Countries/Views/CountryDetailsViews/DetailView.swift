//
//  DetailView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit

class DetailView: UIView {
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentHuggingPriority(for: .horizontal)
        label.numberOfLines = 2
        return label
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    public convenience init(description: String, detailText: String) {
        self.init(frame: .zero)
        self.textLabel.text = detailText
        self.descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubviews(descriptionLabel, textLabel)
        backgroundColor = UIColor.tertiarySystemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            
            textLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
