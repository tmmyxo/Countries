//
//  PlacesView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.10.2021.
//

import UIKit
import CoreLocation
import CoreData

class UserPlacesTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    var mapDelegate: MapData?
    var calloutDelegate: CalloutResponder?
    var userPlaces = [NSManagedObject]()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.contentMode = .center
        label.textColor = .label
        return label
    }()
    
    let tableView: UITableView = {
        let places = UITableView()
        places.translatesAutoresizingMaskIntoConstraints = false
        places.backgroundColor = .tertiarySystemBackground
        places.showsVerticalScrollIndicator = false
        places.separatorStyle = .none
        places.layer.cornerRadius = 16
        places.clipsToBounds = true
        return places
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(PlacesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        descriptionLabel.text = "Your locations"
        setupViews()
        setupConstraints()
        backgroundColor = .tertiarySystemBackground
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubviews(descriptionLabel, tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
    //Table view should be populated by popular places but for demonstration purposes uses countries
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        let userSavedPlace = userPlaces[indexPath.row]
        cell.placeNameLabel.text = userSavedPlace.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = userPlaces[indexPath.row]
        let name = selectedPlace.value(forKeyPath: "name") as! String
        let latitude = selectedPlace.value(forKeyPath: "latitude") as! CLLocationDegrees
        let longitude = selectedPlace.value(forKey: "longitude") as! CLLocationDegrees
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print("selected \(name) at \(location)")
        mapDelegate?.centerMapOnSavedPoint(location: location, pointTitle: name, isSaved: true, managedObject: selectedPlace)
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let commit = userPlaces[indexPath.row]
            appDelegate.persistentContainer.viewContext.delete(commit)
            calloutDelegate?.removeDeletedAnnotation?(managedObject: commit)
            userPlaces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
            
        }
    }
}
