//
//  Userself.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.10.2021.
//
import UIKit
import CoreLocation



class UserCoordinatesView: UIView {
    var delegate: MapData?
    
    lazy var latitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "Latitude"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()

    lazy var longitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .label
        label.text = "Longitude"
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()

    lazy var latitudeField: UITextField = {
        let textfield = TextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 18
        textfield.placeholder = "0"
        textfield.backgroundColor = .systemGray5
        textfield.font = UIFont.systemFont(ofSize: 21)
        textfield.keyboardType = .decimalPad
        return textfield
    }()

    lazy var longitudeField: UITextField = {
        let textfield = TextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 18
        textfield.placeholder = "0"
        textfield.backgroundColor = .systemGray5
        textfield.font = UIFont.systemFont(ofSize: 21)
        textfield.keyboardType = .decimalPad
        return textfield
    }()

    lazy var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 0.16, green: 0.88, blue: 0.75, alpha: 1.00)
        button.tintColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        return button
    }()

    @objc func goButtonTapped() {
        
        let longitude = Double(longitudeField.text!.replacingOccurrences(of: ",", with: ".")) ?? 0
        let latitude = Double(latitudeField.text!.replacingOccurrences(of: ",", with: ".")) ?? 0
        print("\(longitude) || \(latitude)")
        let location = CLLocation(latitude: latitude, longitude: longitude)
        delegate?.centerMapOnNewLocation(location: location, locationName: "User point")
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        addSubviews(latitudeLabel, longitudeLabel, latitudeField, longitudeField, goButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            longitudeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            
            latitudeField.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 10),
            latitudeField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            latitudeField.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10),
            latitudeField.heightAnchor.constraint(equalToConstant: 50),
            
            longitudeField.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 10),
            longitudeField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            longitudeField.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10),
            longitudeField.heightAnchor.constraint(equalToConstant: 50),
            
            latitudeLabel.leadingAnchor.constraint(equalTo: latitudeField.leadingAnchor),
            longitudeLabel.trailingAnchor.constraint(equalTo: longitudeField.trailingAnchor),
            
            goButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            goButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            goButton.heightAnchor.constraint(equalToConstant: 70),
            goButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

