//
//  TabItemView.swift
//  Countries
//
//  Created by Artem Dolbiiev on 21.09.2023.
//

import UIKit

class TabItemView: UIView {

    private let tabItem: TabItem

    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    let itemIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(tabItem: TabItem) {
        self.tabItem = tabItem
        super.init(frame: CGRect.zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.addSubviews(itemIconView, itemTitleLabel)
        itemTitleLabel.text = tabItem.displayTitle
        itemIconView.image = tabItem.icon.withRenderingMode(.automatic)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            itemIconView.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
            itemIconView.widthAnchor.constraint(lessThanOrEqualToConstant: 30),
            itemIconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 5),
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 12),
            itemTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            itemTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -7)
        ])
    }
}
