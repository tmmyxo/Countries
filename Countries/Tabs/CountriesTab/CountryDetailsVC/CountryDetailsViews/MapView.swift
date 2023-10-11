//
//  MapView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.09.2021.
//

import UIKit
import MapKit

class MapView: UIView {

    private var hasFocusedPreviously: Bool = false

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 15
        map.clipsToBounds = true
        return map
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(mapView)
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.shadowColor = Colors.darkShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func focusOnLocation(_ location: CLLocation, area: Float, animated: Bool) {
        if hasFocusedPreviously == false {
            let areaToFocusOn: Float = calculateAreaToFocusOn(area: area)
            mapView.centerMapOnLocationAndSetPin(location, area: areaToFocusOn, animated: animated)
            hasFocusedPreviously = true
        }
    }

    func showWholeWorld() {
        mapView.visibleMapRect = .world
    }

    private func calculateAreaToFocusOn(area: Float) -> Float {
        if area > 8_000_000 {
            return 7_000_000
        } else if area < 1_000_000 {
            return 700_000
        } else {
            return area
        }
    }
}

extension MapView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = Colors.darkShadow.cgColor
    }
}
