//
//  DetailView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit

class CoordinatesView: UIView {
    
    private lazy var latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var longitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Longitude"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var latitudeValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var longitudeValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    public convenience init(latitude: Double, longitude: Double) {
        self.init(frame: .zero)
        self.latitudeValue.text = String(latitude)
        self.longitudeValue.text = String(longitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubviews(latitudeLabel, longitudeLabel, latitudeValue, longitudeValue)
        backgroundColor = UIColor.tertiarySystemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            latitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            longitudeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            longitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            
            latitudeValue.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 15),
            latitudeValue.leadingAnchor.constraint(equalTo: latitudeLabel.leadingAnchor),
            longitudeValue.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 15),
            longitudeValue.leadingAnchor.constraint(equalTo: longitudeLabel.leadingAnchor),
        ])
    }
}
