//
//  CoordinatesService.swift
//  Countries
//
//  Created by Artem Dolbiiev on 13.09.2023.
//

import UIKit.UIApplication
import CoreData.NSManagedObject

class CoordinatesService {

    static var shared = CoordinatesService()

    // MARK: Fetch user's custom points
    func fetchUserCustomPoints(completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustomPoint")
        do {
            let customPointsObjects = try managedContext.fetch(fetchRequest)
            completion(.success(customPointsObjects))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    func saveUserPoint(name: String, longitude: Double, latitude: Double, date: TimeInterval, uid: UUID, completion: @escaping (Result<NSManagedObject, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CustomPoint", in: managedContext)!

        let userPlace = NSManagedObject(entity: entity, insertInto: managedContext)
        userPlace.setValue(name, forKeyPath: "name")
        userPlace.setValue(longitude, forKeyPath: "longitude")
        userPlace.setValue(latitude, forKeyPath: "latitude")
        userPlace.setValue(date, forKeyPath: "createdAt")
        userPlace.setValue(uid, forKeyPath: "uid")

        do {
            try managedContext.save()
            completion(.success(userPlace))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteSavedPoint(for managedObject: NSManagedObject, completion: @escaping (Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(managedObject)
        do {
            try managedContext.save()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
