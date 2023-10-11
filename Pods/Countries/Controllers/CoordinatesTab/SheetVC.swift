//
//  SheetViewController.swift
//  Coordinates
//
//  Created by Artem Dolbiev on 21.10.2021.
//

import UIKit
import CoreLocation
import CoreData

protocol MapData {
    func centerMapOnNewLocation(location: CLLocation, locationName: String)
    func centerMapOnSavedPoint(location: CLLocation, pointTitle: String, isSaved: Bool, managedObject: NSManagedObject)
}


class SheetVC: UIViewController {
    var delegate: MapData?
    
    private lazy var message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .label
        label.text = "Enter coordinates below"
        return label
    }()
    
    lazy var coordinatesView: UserCoordinatesView = {
        let view = UserCoordinatesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        return view
    }()
    
    lazy var popularPlacesTableView: UserPlacesTableView = {
        let places = UserPlacesTableView()
        places.translatesAutoresizingMaskIntoConstraints = false
        places.layer.cornerRadius = 16
        places.layer.shadowColor = UIColor.darkGray.cgColor
        places.layer.shadowOpacity = 0.2
        places.layer.shadowRadius = 2
        places.layer.shadowOffset = CGSize(width: 1, height: 1)
        return places
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDeleate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDeleate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustomPoint")
        
        do {
            popularPlacesTableView.userPlaces = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        loadSubviews()
        addConstraints()
    }
    
    func loadSubviews() {
        view.addSubviews(message, coordinatesView, popularPlacesTableView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            message.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            message.heightAnchor.constraint(equalToConstant: 25),
            message.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            coordinatesView.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 25),
            coordinatesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            coordinatesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            coordinatesView.heightAnchor.constraint(equalToConstant: 190),
            
            popularPlacesTableView.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 20),
            popularPlacesTableView.leadingAnchor.constraint(equalTo: coordinatesView.leadingAnchor),
            popularPlacesTableView.trailingAnchor.constraint(equalTo: coordinatesView.trailingAnchor),
            popularPlacesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
            
        ])
    }
}
