//
//  SavedPointCallout.swift
//  Countries
//
//  Created by Artem Dolbiev on 25.11.2021.
//

import UIKit
import MapKit

class SavedPointCallout: UIView {
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
    
    var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemMint
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pointNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Label"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
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
    
    var editPointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var deletePointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var editingTextField: UITextField = {
        var textfield = TextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Enter new title"
        textfield.backgroundColor = .systemOrange
        textfield.textColor = .white
        textfield.font = UIFont.boldSystemFont(ofSize: 20)
        textfield.alpha = 0
        textfield.clearButtonMode = .whileEditing
        textfield.padding.left = 10
        textfield.tintColor = .black
        return textfield
    }()
    
    var finishedEditingButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemMint
        button.tintColor = .white
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.addTarget(self, action: #selector(finishedEditing), for: .touchUpInside)
        return button
    }()
    
    func configure() {
        
        self.addSubviews(titleView, detailView, editPointButton, deletePointButton)
        titleView.addSubview(pointNameLabel)
        detailView.addSubviews(latitudeLabel, latitudeValuelabel, longitudeLabel, longitudeValuelabel)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 165),
            self.widthAnchor.constraint(equalToConstant: 250),
            
            titleView.topAnchor.constraint(equalTo: self.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 35),
            
            pointNameLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            pointNameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            pointNameLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            pointNameLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            
            detailView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            
            editPointButton.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            editPointButton.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            editPointButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            editPointButton.bottomAnchor.constraint(equalTo: detailView.centerYAnchor),
            
            deletePointButton.topAnchor.constraint(equalTo: editPointButton.bottomAnchor),
            deletePointButton.leadingAnchor.constraint(equalTo: editPointButton.leadingAnchor),
            deletePointButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deletePointButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
            
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

extension SavedPointCallout {
    
    
    
    @objc func deleteButtonTapped() {
        delegate?.calloutDeleteButtonTapped?(annotation: annotation)
        print("Inside button function")
    }
    
    @objc func editButtonTapped() {
        editingTextField.text = pointNameLabel.text
        setupEditinigViews()
        editingTextField.becomeFirstResponder()
    }
    
    @objc func finishedEditing() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.editingTextField.alpha = 0
            } completion: { _ in
                self.editingTextField.removeFromSuperview()
            }
            self.finishedEditingButton.removeFromSuperview()
        }
        if editingTextField.text != "" {
            let mapAnnotation = annotation as! MapAnnotation
            delegate?.calloutEditButtonTapped?(managedObject: mapAnnotation.managedObject!, newTitleForAnnotation: editingTextField.text!)
            pointNameLabel.text = editingTextField.text
        } else {
            let emptyFieldAlert = UIAlertController(title: "New name can't be empty", message: nil, preferredStyle: .alert)
            emptyFieldAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            delegate?.alertUserWithNotification?(alertNotification: emptyFieldAlert)
        }
    }
    
    func setupEditinigViews() {
        editingTextField.placeholder = pointNameLabel.text
        self.addSubviews(editingTextField, finishedEditingButton)
        NSLayoutConstraint.activate([
            editingTextField.topAnchor.constraint(equalTo: self.topAnchor),
            editingTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            editingTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            editingTextField.heightAnchor.constraint(equalToConstant: 35),
            
            finishedEditingButton.topAnchor.constraint(equalTo: editingTextField.bottomAnchor),
            finishedEditingButton.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            finishedEditingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            finishedEditingButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calloutSize),
        ])
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.editingTextField.alpha = 1
            }
        }
        
    }

}

