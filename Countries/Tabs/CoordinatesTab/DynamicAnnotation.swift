//
//  AnnotationViewModel.swift
//  Countries
//
//  Created by Artem Dolbiiev on 06.09.2023.
//

import MapKit

final class DynamicAnnotation: NSObject, MKAnnotation {

    @objc dynamic var coordinate: CLLocationCoordinate2D


    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
