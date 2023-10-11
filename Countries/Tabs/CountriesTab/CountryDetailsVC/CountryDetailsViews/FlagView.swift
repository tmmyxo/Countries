//
//  FlagView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.09.2021.
//

import UIKit

class FlagView: UIView {

    private var flagAspectRatio: CGFloat

    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textColor = Colors.label
        return label
    }()

    private lazy var flagImageView: UIImageView = {
        let flag = UIImageView()
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.contentMode = .scaleAspectFit
        flag.clipsToBounds = true
        flag.layer.cornerRadius = 13
        flag.layer.cornerCurve = .continuous
        return flag
    }()
    
    init(flagImage: UIImage, countryName: String) {
        self.flagAspectRatio = flagImage.getAspectRatio()
        super.init(frame: .zero)
        self.countryNameLabel.text = countryName
        self.flagImageView.image = flagImage
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(countryNameLabel, flagImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            countryNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 70),
            countryNameLabel.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor),
            countryNameLabel.trailingAnchor.constraint(equalTo: flagImageView.trailingAnchor),

            flagImageView.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 15),
            flagImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            flagImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 1/flagAspectRatio),
            flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
