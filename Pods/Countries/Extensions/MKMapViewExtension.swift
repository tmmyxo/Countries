//
//  MKMapViewExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.09.2021.
//

import MapKit

public extension MKMapView {
    func centerMapOnLocation(_ location: CLLocation, area: Float) {
        
        let regionRadius: CLLocationDistance = Double(area)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        self.addAnnotation(annotation)
    }
}
