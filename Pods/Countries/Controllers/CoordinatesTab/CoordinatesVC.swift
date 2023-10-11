//
//  ViewController.swift
//  Coordinates
//
//  Created by Artem Dolbiev on 19.10.2021.
//

import UIKit
import MapKit
import CoreData


class CoordinatesVC: UIViewController, MKMapViewDelegate, MapData, CalloutResponder {
    
    var managedObjectContext = NSPersistentContainer(name: "CustomPoints").viewContext
    let calloutAnimator = MapAnnotationAnimator()
    let generator = UISelectionFeedbackGenerator()
    

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let locationLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.contentInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        label.isHidden = true
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowOpacity = 0.2
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        return label
    }()
    
    private let locationLabelUnderlayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
//    private let button: CustomButton = {
//        let button = CustomButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .systemBackground
//        button.tintColor = .label
//        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
//        button.layer.cornerRadius = 0.5 * button.bounds.size.width
//        button.layer.shadowColor = UIColor.darkGray.cgColor
//        button.layer.shadowRadius = 3
//        button.layer.shadowOpacity = 0.2
//        button.layer.shadowOffset = CGSize(width: 0, height: 0)
//        button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
//        return button
//    }()
    
    
    
    private let userLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .label
        button.layer.cornerRadius = 12
        button.setImage(UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17)), for: .normal)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        return button
    }()
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            locationLabelUnderlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            locationLabelUnderlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabelUnderlayer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            locationLabelUnderlayer.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: locationLabelUnderlayer.topAnchor),
            locationLabel.centerXAnchor.constraint(equalTo: locationLabelUnderlayer.centerXAnchor),
            locationLabel.heightAnchor.constraint(equalTo: locationLabelUnderlayer.heightAnchor),
            locationLabel.widthAnchor.constraint(equalTo: locationLabelUnderlayer.widthAnchor),
            
            userLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            userLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userLocationButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 37),
            userLocationButton.widthAnchor.constraint(equalToConstant: 37),
            
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.heightAnchor.constraint(equalToConstant: 65),
//            button.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(mapView, locationLabelUnderlayer, userLocationButton)
        locationLabelUnderlayer.addSubview(locationLabel)
        view.backgroundColor = .secondarySystemBackground
        mapView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(centerMapOnLongPressLocation))
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(openSheet), name: Notification.Name("TabBarSearchTapped"), object: nil)
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let mapAnnotation = annotation as! MapAnnotation
        let identifier = NSStringFromClass(MapAnnotation.self)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            
            annotationView?.layer.shadowColor = UIColor.darkGray.cgColor
            annotationView?.layer.shadowOpacity = 0.1
            annotationView?.layer.shadowRadius = 3
            annotationView?.layer.shadowOffset = CGSize(width: 1, height: 1)
        } else {
            annotationView!.annotation = annotation
        }
        
        if mapAnnotation.isUserLocation {
            annotationView?.image = UIImage(named: "userLocation")
            annotationView?.frame.size = CGSize(width: 22, height: 22)
        } else if mapAnnotation.isSaved {
            annotationView?.image = UIImage(named: "pinMint")
            annotationView?.frame.size = CGSize(width: 30, height: 35)
        } else {
            annotationView?.image = UIImage(named: "pinOrange")
            annotationView?.frame.size = CGSize(width: 30, height: 35)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let visibleRect = mapView.annotationVisibleRect
        for view: MKAnnotationView in views {
            let endFrame: CGRect = view.frame
            var startFrame: CGRect = endFrame
            startFrame.origin.y = visibleRect.origin.y - startFrame.size.height
            view.frame = startFrame
            UIView.animate(withDuration: 0.3) {
                view.frame = endFrame
            }
        }
    }
    
    // DID SELECT ANNOTATION
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        
        if view.annotation is MKUserLocation {
            return
        }
        let annotation = view.annotation as! MapAnnotation
        
        if annotation.isSaved {
            let calloutView = SavedPointCallout()
            calloutView.pointNameLabel.text = annotation.title
            calloutView.delegate = self
            calloutView.annotation = annotation
            calloutView.longitudeValuelabel.text = String(annotation.location.coordinate.longitude)
            calloutView.latitudeValuelabel.text = String(annotation.location.coordinate.latitude)
            view.addSubview(calloutView)
            calloutView.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
            calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calloutAnimator.show(calloutView)
        } else {
            let calloutView = CustomCalloutView()
            calloutView.delegate = self
            calloutView.annotation = annotation
            calloutView.longitudeValuelabel.text = String(annotation.location.coordinate.longitude)
            calloutView.latitudeValuelabel.text = String(annotation.location.coordinate.latitude)
            view.addSubview(calloutView)
            calloutView.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
            calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calloutAnimator.show(calloutView)
        }
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    // DID DESELECT ANNOTATION
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self){
            for subview in view.subviews {
                if subview is CustomCalloutView || subview is SavedPointCallout {
                    calloutAnimator.hide(subview)
                }
            }
        }
    }
    
    // SAVING CUSTOM USER POINT
    
    func calloutAddButtonTapped(annotation: MKAnnotation) {
        let alertController = UIAlertController(title: "Enter a name for your custom point", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak alertController] _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let annotation = annotation as! MapAnnotation
            let name = alertController?.textFields?[0].text
            let longitude = annotation.coordinate.longitude
            let latitude = annotation.coordinate.latitude
            let date = Date().timeIntervalSince1970
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "CustomPoint", in: managedContext)!
            
            let userPlace = NSManagedObject(entity: entity, insertInto: managedContext)
            
            userPlace.setValue(name, forKeyPath: "name")
            userPlace.setValue(longitude, forKeyPath: "longitude")
            userPlace.setValue(latitude, forKeyPath: "latitude")
            userPlace.setValue(date, forKeyPath: "createdAt")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            annotation.isSaved = true
            self?.mapView.deselectAnnotation(annotation, animated: true)
            self?.mapView.removeAnnotation(annotation)
            self?.centerMapOnSavedPoint(location: annotation.location, pointTitle: name ?? "No Title", isSaved: annotation.isSaved, managedObject: userPlace)
        }))
        present(alertController, animated: true)
    }
    
    // DELETING CUSTOM USER POINT
    
    func calloutDeleteButtonTapped(annotation: MKAnnotation) {
        print("inside protocol function")
        let alertController = UIAlertController(title: "Are you sure you want to delete this point?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self, weak alertController] _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let annotation = annotation as! MapAnnotation
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(annotation.managedObject!)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self?.mapView.removeAnnotation(annotation)
            self!.mapView.deselectAnnotation(annotation, animated: true)
        }))
        present(alertController, animated: true)
    }
    
    // EDIT CUSTOM USER POINT
    
    func calloutEditButtonTapped(managedObject: NSManagedObject, newTitleForAnnotation: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObject.setValue(newTitleForAnnotation, forKeyPath: "name")
        appDelegate.saveContext()
//
//        do {
//            try appDelegate.saveContext()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    // ALERTS USER WITH PROVIDED NOTIFICATIONS
    
    func alertUserWithNotification(alertNotification: UIAlertController) {
        present(alertNotification, animated: true)
    }
    
    // REMOVES ANNOTATION FOR DELETED POINT
    
    func removeDeletedAnnotation(managedObject: NSManagedObject) {
        for annotation in mapView.annotations {
            if annotation.title == managedObject.value(forKeyPath: "name") as? String {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    
    // ACTIONS
    @objc func centerMapOnUserLocation() {
        LocationManager.shared.getUserLocation { [weak self] location in
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            
            let pin = MapAnnotation(title: "You're here", coordinate: location.coordinate, isUserLocation: true, isSaved: false)
            self!.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
            self!.mapView.addAnnotation(pin)
            self!.resolveLocation(at: location)
        }
    }
    
    @objc public func centerMapOnNewLocation(location: CLLocation, locationName: String) {
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let pin = MapAnnotation(title: "Custom point", coordinate: location.coordinate, isUserLocation: false, isSaved: false)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
        mapView.addAnnotation(pin)
    }
    
    @objc func centerMapOnLongPressLocation(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            generator.selectionChanged()
            let touchpoint = gestureRecognizer.location(in: mapView)
            let wayCoords = mapView.convert(touchpoint, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: wayCoords.latitude, longitude: wayCoords.longitude)
            let span = mapView.region.span
            let pin = MapAnnotation(title: "Custom point", coordinate: location.coordinate, isUserLocation: false, isSaved: false)
            mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
            mapView.addAnnotation(pin)
            resolveLocation(at: location)
        default: break
        }
        
    }
    
    func centerMapOnSavedPoint(location: CLLocation, pointTitle: String, isSaved: Bool = false, managedObject: NSManagedObject) {
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        
        let pin = MapAnnotation(title: pointTitle, coordinate: location.coordinate, isUserLocation: false, isSaved: true)
        pin.managedObject = managedObject
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
        mapView.addAnnotation(pin)
        resolveLocation(at: location)
    }
    
    func addMapPin(at location: CLLocation, with title: String, isUserLocation: Bool = false) {
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        
        let pin = MapAnnotation(title: title, coordinate: location.coordinate, isUserLocation: isUserLocation, isSaved: false)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
        mapView.addAnnotation(pin)
        
        resolveLocation(at: location)
    }
    
    @objc func openSheet() {
        let sheetController = SheetVC()
        sheetController.delegate = self
        sheetController.popularPlacesTableView.calloutDelegate = self
        sheetController.popularPlacesTableView.mapDelegate = self
        sheetController.coordinatesView.delegate = self
        if let sheet = sheetController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 24.0
        }
        self.present(sheetController, animated: true, completion: nil)
    }
}


extension CoordinatesVC {
    func resolveLocation(at location: CLLocation) {
        LocationManager.shared.resolveLocationName(with: location) { locationName in
            if locationName == "" {
                self.locationLabel.isHidden = true
            } else {
                self.locationLabel.text = locationName
                self.locationLabel.isHidden = false
            }
        }
    }
}
