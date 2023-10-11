//
//  NoUserPlacesPlaceholderCell.swift
//  Countries
//
//  Created by Artem Dolbiiev on 05.09.2023.
//

import UIKit

class NoUserPlacesPlaceholderCell: UIView {

    private lazy var messageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "mappin.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Saved points will be displayed here")
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .systemGray2
        label.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(messageLabel, messageImage)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            messageImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            messageImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),

            messageLabel.topAnchor.constraint(equalTo: messageImage.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            messageLabel.centerXAnchor.constraint(equalTo: messageImage.centerXAnchor)
        ])
    }
}
