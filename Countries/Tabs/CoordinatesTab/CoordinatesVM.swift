//
//  CoordinatesVM.swift
//  Countries
//
//  Created by Artem Dolbiiev on 13.09.2023.
//

import Foundation
import CoreData.NSManagedObject
import MapKit

class CoordinatesViewModel {
    var errorHandler: ((Error) -> Void)?
    private var userCustomPoints = [MapAnnotation]()
    private var userLocation: MapAnnotation?

    func fetchUserSavedPoints(completion: @escaping () -> Void) {
        CoordinatesService.shared.fetchUserCustomPoints { result in
            switch result {
            case .success(let managedObjects):
                self.makeMapAnnotationsForSavedPoints(from: managedObjects) {
                    completion()
                }
            case .failure(let error):
                self.errorHandler?(error)
            }
        }

    }

    private func makeMapAnnotationsForSavedPoints(from objects: [NSManagedObject], completion: @escaping () -> Void) {
        for object in objects {
            let name = object.value(forKeyPath: "name") as! String
            let uid = object.value(forKeyPath: "uid") as! UUID
            let latitude = object.value(forKeyPath: "latitude") as! CLLocationDegrees
            let longitude = object.value(forKeyPath: "longitude") as! CLLocationDegrees
            let location = CLLocation(latitude: latitude, longitude: longitude)

            let isAnnotationAlreadyAdded = userCustomPoints.contains { annotation in
                return annotation.uid == uid
            }

            if isAnnotationAlreadyAdded {
                return
            } else {
                let userPin = MapAnnotation(title: name, uid: uid, coordinate: location.coordinate, isUserLocation: false, isSaved: true)
                userPin.managedObject = object
                userCustomPoints.append(userPin)
            }
        }
        completion()
    }

    func saveUserPoint(for annotation: MapAnnotation, completion: @escaping (MapAnnotation) -> Void) {
        CoordinatesService.shared.saveUserPoint(
            name: annotation.title ?? String(localized: "Unnamed Point"),
            longitude: annotation.coordinate.longitude,
            latitude: annotation.coordinate.latitude,
            date: Date().timeIntervalSince1970,
            uid: UUID())
        { result in
            
            switch result {
            case .success(let managedObject):

                let title = managedObject.value(forKeyPath: "name") as! String
                let uid = managedObject.value(forKeyPath: "uid") as! UUID

                if annotation.isUserLocation {
                    let mapAnnotation = MapAnnotation(title: title, uid: uid, coordinate: annotation.coordinate, isUserLocation: false, isSaved: true)
                    mapAnnotation.managedObject = managedObject
                    self.userCustomPoints.append(mapAnnotation)
                    completion(mapAnnotation)
                } else {
                    annotation.title = title
                    annotation.uid = uid
                    annotation.isSaved = true
                    annotation.managedObject = managedObject
                    annotation.isUserLocation = false
                    self.userCustomPoints.append(annotation)
                    completion(annotation)
                }
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }

    func deleteSavedPoint(for annotation: MKAnnotation, completion: @escaping () -> Void) {
        guard let annotation = annotation as? MapAnnotation,
              let managedObject = annotation.managedObject,
              annotation.isSaved
        else {
            completion()
            return
        }
        CoordinatesService.shared.deleteSavedPoint(for: managedObject) { error in
            if let error = error {
                self.errorHandler?(error)
            } else {
                self.removeSavedPointFromArray(for: annotation)
                completion()
            }
        }
    }

    private func removeSavedPointFromArray(for annotation: MapAnnotation) {
        self.userCustomPoints.removeAll { savedAnnotation in
            return savedAnnotation.uid == annotation.uid
        }
    }

    func getUserSavedPoints() -> [MapAnnotation] {
        return userCustomPoints
    }

    func setCurrentUserLocation(using annotation: MapAnnotation) {
        self.userLocation = annotation
    }

    func getUserLocation() -> MapAnnotation? {
        return self.userLocation
    }
}
