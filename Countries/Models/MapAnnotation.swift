//
//  MapAnnotation.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 08.11.2021.
//

import UIKit
import MapKit
import CoreData

class MapAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D

    var location: CLLocation

    var title: String?
    var uid: UUID

    var isUserLocation: Bool = false
    var isSaved: Bool = false
    
    var managedObject: NSManagedObject?
    
    init(title: String, uid: UUID, coordinate: CLLocationCoordinate2D, isUserLocation: Bool, isSaved: Bool) {
        self.coordinate = coordinate
        self.title = title
        self.uid = uid
        self.isUserLocation = isUserLocation
        self.isSaved = isSaved
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
