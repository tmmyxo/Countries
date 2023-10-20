//
//  SavedPointCallout.swift
//  Countries
//
//  Created by Artem Dolbiev on 25.11.2021.
//

import UIKit
import MapKit

class SavedPointCallout: CustomCallout {

    private var annotation: MapAnnotation

    private lazy var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.detailMint
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var pointNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.labelFlipped
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var detailView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        return view
    }()

    lazy var latitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = String(localized: "Latitude:")
        label.textColor = Colors.label
        return label
    }()

    lazy var longitudeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = String(localized: "Longitude:")
        label.textColor = Colors.label
        return label
    }()

    lazy var latitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Colors.label
        return label
    }()

    lazy var longitudeValuelabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Colors.label
        return label
    }()

    private lazy var editPointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = Colors.detailOrange
        button.tintColor = Colors.labelFlipped
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var deletePointButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.backgroundColor = Colors.detailRed
        button.tintColor = Colors.labelFlipped
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editingTextField: UITextField = {
        var textfield = TextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = String(localized: "Enter new title")
        textfield.backgroundColor = Colors.detailOrange
        textfield.textColor = Colors.labelFlipped
        textfield.font = UIFont.boldSystemFont(ofSize: 20)
        textfield.alpha = 0
        textfield.clearButtonMode = .whileEditing
        textfield.padding.left = 10
        textfield.tintColor = .black
        return textfield
    }()

    private lazy var finishedEditingButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.detailMint
        button.tintColor = Colors.labelFlipped
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.addTarget(self, action: #selector(finishedEditing), for: .touchUpInside)
        return button
    }()

    // MARK: Init
    init(annotation: MapAnnotation) {
        self.annotation = annotation
        super.init(frame: CGRect.zero)
        pointNameLabel.text = annotation.title
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
        let shapeLayer = CalloutShape(for: self)
        layer.mask = shapeLayer
    }
    
    private func configure() {
        self.addSubviews(titleView, detailView, editPointButton, deletePointButton)
        titleView.addSubview(pointNameLabel)
        detailView.addSubviews(latitudeLabel, latitudeValuelabel, longitudeLabel, longitudeValuelabel)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

// MARK: Constraints setup
    private func setupConstraints() {
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
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -annotationViewSize),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            
            editPointButton.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            editPointButton.leadingAnchor.constraint(equalTo: detailView.trailingAnchor),
            editPointButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            editPointButton.bottomAnchor.constraint(equalTo: detailView.centerYAnchor),
            
            deletePointButton.topAnchor.constraint(equalTo: editPointButton.bottomAnchor),
            deletePointButton.leadingAnchor.constraint(equalTo: editPointButton.leadingAnchor),
            deletePointButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deletePointButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -annotationViewSize),
            
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

    private func setupEditinigViews() {
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
             finishedEditingButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -annotationViewSize),
         ])

         UIView.animate(withDuration: 0.2) {
             self.editingTextField.alpha = 1
         }
     }
}

extension SavedPointCallout {
    @objc func deleteButtonTapped() {
        delegate?.calloutDeleteButtonTapped?(annotation: annotation)
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
            delegate?.calloutEditButtonTapped?(annotation: self.annotation, newTitleForAnnotation: editingTextField.text!)
            pointNameLabel.text = editingTextField.text
        }
    }
}
