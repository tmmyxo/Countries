//
//  DetailCalloutView.swift
//  Countries
//
//  Created by Artem Dolbiev on 15.11.2021.
//

import UIKit

class DetailCalloutView: UIView {
    
    private var latitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Latitude:"
        return label
    }()
    
    private var longitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Longitude:"
        return label
    }()
    
    var latitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var longitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubviews(latitudeLabel, longitudeLabel, latitudeValuelabel, longitudeValuelabel)
        
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            latitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            latitudeValuelabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 7),
            latitudeValuelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            latitudeValuelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            longitudeValuelabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            longitudeValuelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            longitudeValuelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            longitudeLabel.bottomAnchor.constraint(equalTo: longitudeValuelabel.topAnchor, constant: -7),
            longitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ])
    }
}
