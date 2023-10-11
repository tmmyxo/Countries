//
//  CustomAnnotation.swift
//  Countries
//
//  Created by Artem Dolbiev on 09.11.2021.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class CalloutView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    var detailView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var latitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Latitude:"
        return label
    }()
    
    var longitudeLabel: UILabel = {
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
    
    var rightButtonView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    
    var savePointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.tintColor = .white
        return button
    }()
}


private extension CalloutView {
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.addSubviews(detailView, rightButtonView)
        detailView.addSubviews(latitudeLabel, latitudeValuelabel, longitudeLabel, longitudeValuelabel)
        rightButtonView.addSubview(savePointButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 130),
            self.widthAnchor.constraint(equalToConstant: 250),
            
            detailView.topAnchor.constraint(equalTo: self.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            
            rightButtonView.topAnchor.constraint(equalTo: self.topAnchor),
            rightButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightButtonView.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            
            
            
            latitudeLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
            latitudeLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            
            latitudeValuelabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 7),
            latitudeValuelabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            latitudeValuelabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
            
            longitudeValuelabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -10),
            longitudeValuelabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            longitudeValuelabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
            
            longitudeLabel.bottomAnchor.constraint(equalTo: longitudeValuelabel.topAnchor, constant: -7),
            longitudeLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            
            
            savePointButton.centerXAnchor.constraint(equalTo: rightButtonView.centerXAnchor),
            savePointButton.centerYAnchor.constraint(equalTo: rightButtonView.centerYAnchor),
            
        ])
        
    }
}
