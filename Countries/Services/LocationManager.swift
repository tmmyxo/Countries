//
//  LocationManager.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 04.11.2021.
//

import Foundation
import CoreLocation

typealias FullLocationName = String
typealias ShortLocationName = String

struct LocationName: Comparable {
    var fullLocationName = FullLocationName()
    var shortLocationName = ShortLocationName()

    static func < (lhs: LocationName, rhs: LocationName) -> Bool {
        return lhs.fullLocationName == rhs.fullLocationName && lhs.shortLocationName == rhs.shortLocationName
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping((LocationName?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first else {
                completion(nil)
                return
            }

            var locationName = LocationName()

            if let country = place.country {
                locationName.fullLocationName += "\(country), "
                locationName.shortLocationName += "\(country), "
            }

            if let city = place.locality {
                locationName.fullLocationName += "\(city), "
                locationName.shortLocationName += "\(city)"
            }

            if let streetName = place.thoroughfare {
                locationName.fullLocationName += "\(streetName), "
            }

            if let streetNumber = place.subThoroughfare {
                locationName.fullLocationName += "\(streetNumber), "
            }

            if let zipcode = place.postalCode {
                locationName.fullLocationName += String(localized: "\nPostal code: \(zipcode)")
            }

            completion(locationName)
        }
    }
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
}
