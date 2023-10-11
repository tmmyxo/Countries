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
    @objc optional func calloutEditButtonTapped(annotation: MapAnnotation, newTitleForAnnotation: String)
    @objc optional func removeDeletedAnnotation(annotation: MapAnnotation)
}

class CustomCallout: UIView {
    var delegate: CalloutResponder?

    var lineWidth: CGFloat = 1 { didSet { setNeedsDisplay() }}
    var cornerRadius: CGFloat = 16 { didSet { setNeedsDisplay() }}
    var calloutSize: CGFloat = 10 { didSet { setNeedsDisplay() }}
    var fillColor: UIColor = Colors.backgroundColor { didSet { setNeedsDisplay() }}
    var strokeColor: UIColor = Colors.backgroundColor { didSet { setNeedsDisplay() }}

    static func getRespectiveCallout(for annotation: MapAnnotation) -> CustomCallout {
        if annotation.isSaved {
            return SavedPointCallout(annotation: annotation)
        } else {
            return UnsavedPointCalloutView(annotation: annotation)
        }
    }
}

class UnsavedPointCalloutView: CustomCallout {

    private var annotation: MapAnnotation

    private lazy var detailView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.clipsToBounds = true
        return view
    }()

    private lazy var latitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = String(localized: "Latitude:")
        label.textColor = Colors.label
        return label
    }()

    private lazy var longitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = String(localized: "Longitude:")
        label.textColor = Colors.label
        return label
    }()

    private lazy var latitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Colors.label
        return label
    }()

    private lazy var longitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Colors.label
        return label
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()


    private lazy var savePointButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = Colors.detailBlue
        button.tintColor = Colors.labelFlipped
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var deletePointButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = Colors.detailRed
        button.tintColor = Colors.labelFlipped
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Init
    init(annotation: MapAnnotation) {
        self.annotation = annotation
        super.init(frame: CGRect.zero)
        longitudeValuelabel.text = String(annotation.location.coordinate.longitude)
        latitudeValuelabel.text = String(annotation.location.coordinate.latitude)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        configure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Custom callout draw
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

    // MARK: Constraints setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 130),
            self.widthAnchor.constraint(equalToConstant: 250),

            detailView.topAnchor.constraint(equalTo: self.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),

            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),

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

    private func configure() {
        self.addSubviews(detailView, buttonsStackView)
        self.buttonsStackView.addArrangedSubview(savePointButton)
        self.buttonsStackView.addArrangedSubview(deletePointButton)
        detailView.addSubviews(latitudeLabel, latitudeValuelabel, longitudeLabel, longitudeValuelabel)
        checkIfAtUserLocation()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)

    }

    private func checkIfAtUserLocation() {
            deletePointButton.isHidden = annotation.isUserLocation
    }
}

extension UnsavedPointCalloutView {

    // MARK: Actions
    @objc func addButtonTapped() {
        delegate?.calloutAddButtonTapped?(annotation: annotation)
    }

    @objc func deleteButtonTapped() {
        delegate?.calloutDeleteButtonTapped?(annotation: annotation)
    }
}
