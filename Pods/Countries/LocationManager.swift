//
//  LocationManager.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 04.11.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            var locationName = ""
            if let locality = place.locality {
                if locality != place.country {
                    locationName += "\(locality), "
                }
            }

            if let country = place.country {
                locationName += country
            }
            completion(locationName)
            
            //            if let adminRegion = place.administrativeArea {
            //                locationName += ", \(adminRegion)"
            //            }
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
