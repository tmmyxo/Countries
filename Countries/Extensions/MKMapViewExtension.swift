//
//  MKMapViewExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 29.09.2021.
//

import MapKit

public extension MKMapView {
    func centerMapOnLocationAndSetPin(_ location: CLLocation, area: Float, animated: Bool) {
        let regionRadius: CLLocationDistance = Double(area)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.setRegion(coordinateRegion, animated: animated)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        self.addAnnotation(annotation)
    }

    func centerMapOnLocation(_ location: CLLocation, span: CGFloat, completion: @escaping () -> Void) {
        let region = createRegion(for: location, with: span)
        MKMapView.animate(withDuration: 0.6) {
            self.region = region
        } completion: { _ in
            completion()
        }
    }

    func createRegion(for location: CLLocation, with span: CGFloat) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        return MKCoordinateRegion(center: location.coordinate, span: span)
    }

    func checkIfLocationVisible(location: CLLocationCoordinate2D) -> Bool {
        return self.visibleMapRect.contains(MKMapPoint(location))
    }

}
