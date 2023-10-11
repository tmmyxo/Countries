//
//  CustomCalloutView.swift
//  Countries
//
//  Created by Artem Dolbiev on 19.11.2021.
//

import UIKit
import MapKit
import CoreData

@objc protocol CalloutResponder {
    @objc optional func calloutAddButtonTapped(annotation: MKAnnotation)
    @objc optional func calloutDeleteButtonTapped(annotation: MKAnnotation)
    @objc optional func calloutEditButtonTapped(managedObject: NSManagedObject, newTitleForAnnotation: String)
    @objc optional func removeDeletedAnnotation(managedObject: NSManagedObject)
    @objc optional func alertUserWithNotification(alertNotification: UIAlertController)
}

class CustomCalloutView: UIView {
    var lineWidth: CGFloat = 1 { didSet { setNeedsDisplay() }}
    var cornerRadius: CGFloat = 16 { didSet { setNeedsDisplay() }}
    var calloutSize: CGFloat = 10 { didSet { setNeedsDisplay() }}
    var fillColor: UIColor = .systemBackground { didSet { setNeedsDisplay() }}
    var strokeColor: UIColor = .systemBackground { didSet { setNeedsDisplay() }}
    
    var annotation: MKAnnotation!
    var delegate: CalloutResponder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        configure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Drawing custom callout bubble
    
    override func draw(_ rect: CGRect) {
        let rect = bounds
        let path = UIBezierPath()
        
        // lower left corner
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - calloutSize))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - calloutSize - cornerRadius), controlPoint: CGPoint(x: rect.minX, y: rect.maxY - calloutSize))
        
        // left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // upper left corner
        
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        
        // top
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // upper right corner
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        // right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - calloutSize - cornerRadius))
        
        // lower right corner
        path.addQuadCurve(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - calloutSize),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.maxY - calloutSize))
        
        // bottom (including callout)
        path.addLine(to: CGPoint(x: rect.midX + calloutSize, y: rect.maxY - calloutSize))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - calloutSize, y: rect.maxY - calloutSize))
        path.close()
        
        fillColor.setFill()
        path.fill()
        path.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
    
    //Setting up the UI
    
    var detailView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
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
    
    
    var savePointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func configure() {
        self.addSubviews(detailView, savePointButton)
        
        detailView.addSubviews(latitudeLabel, latitudeValuelabel, longitudeLabel, longitudeValuelabel)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 130),
            self.widthAnchor.constraint(equalToConstant: 250),
            
            detailView.topAnchor.constraint(equalTo: self.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            
            savePointButton.topAnchor.constraint(equalTo: self.topAnchor),
            savePointButton.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            savePointButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            savePointButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
            
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
            
        ])
    }
}

extension CustomCalloutView {
    @objc func addButtonTapped() {
        delegate?.calloutAddButtonTapped?(annotation: annotation)
    }
}
