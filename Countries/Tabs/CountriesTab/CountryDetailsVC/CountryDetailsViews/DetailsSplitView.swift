//
//  DetailView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit

class DetailsSplitView: UIView {

    var spacing: CGFloat = 60 {
        didSet {
            self.updateLeftAndRightViewSpacing()
        }
    }

    private var leftViewTrailingAnchor: NSLayoutConstraint!
    private var rightViewLeadingAnchor: NSLayoutConstraint!

    private lazy var leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()

    private lazy var rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()

    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    init(leftTitle: String, leftText: String, rightTitle: String, rightText: String) {
        super.init(frame: .zero)
        self.leftTitleLabel.text = leftTitle
        self.rightTitleLabel.text = rightTitle
        self.leftTextLabel.text = leftText
        self.rightTextLabel.text = rightText
        self.leftTextLabel.setParagraphSpacing(8)
        self.rightTextLabel.setParagraphSpacing(8)
        setupView()
        setupConstraints()
    }

    override func layoutSubviews() {
        leftView.layer.cornerRadius = self.layer.cornerRadius
        rightView.layer.cornerRadius = self.layer.cornerRadius
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.shadowColor = Colors.darkShadow.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubviews(leftView, rightView)
        leftView.addSubviews(leftTitleLabel, leftTextLabel)
        rightView.addSubviews(rightTitleLabel, rightTextLabel)
    }
    
    private func setupConstraints() {
        leftViewTrailingAnchor = leftView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -(spacing / 2))
        rightViewLeadingAnchor = rightView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: spacing / 2)
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: self.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftViewTrailingAnchor,

            leftTitleLabel.topAnchor.constraint(equalTo: leftView.topAnchor, constant: 15),
            leftTitleLabel.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 10),
            leftTitleLabel.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -10),

            leftTextLabel.topAnchor.constraint(equalTo: leftTitleLabel.bottomAnchor, constant: 12),
            leftTextLabel.leadingAnchor.constraint(equalTo: leftTitleLabel.leadingAnchor),
            leftTextLabel.trailingAnchor.constraint(equalTo: leftTitleLabel.trailingAnchor),
            leftTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -15),

            rightView.topAnchor.constraint(equalTo: self.topAnchor),
            rightViewLeadingAnchor,
            rightView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            rightTitleLabel.topAnchor.constraint(equalTo: rightView.topAnchor, constant: 15),
            rightTitleLabel.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 10),
            rightTitleLabel.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -10),

            rightTextLabel.topAnchor.constraint(equalTo: rightTitleLabel.bottomAnchor, constant: 12),
            rightTextLabel.leadingAnchor.constraint(equalTo: rightTitleLabel.leadingAnchor),
            rightTextLabel.trailingAnchor.constraint(equalTo: rightTitleLabel.trailingAnchor),
            rightTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -15)
        ])
    }

    private func updateLeftAndRightViewSpacing() {
        leftViewTrailingAnchor.constant = -(spacing / 2)
        rightViewLeadingAnchor.constant = spacing / 2
        layoutIfNeeded()
    }
}

extension DetailsSplitView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = Colors.darkShadow.cgColor
    }
}
