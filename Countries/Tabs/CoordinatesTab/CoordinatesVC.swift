//
//  ViewController.swift
//  Coordinates
//
//  Created by Artem Dolbiev on 19.10.2021.
//

import UIKit
import MapKit
import CoreData


class CoordinatesVC: UIViewController, MKMapViewDelegate {

    private var viewModel = CoordinatesViewModel()
    private var animator: MapAnnotationAnimator!
    private let selectionHapticGenerator = UISelectionFeedbackGenerator()
    private let notificationHapticGenerator = UINotificationFeedbackGenerator()

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var locationLabel: ExpandableLocationLabel = {
        let view = ExpandableLocationLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = Colors.darkShadow.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.isExclusiveTouch = true
        return view
    }()
    
    private lazy var userLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.backgroundColor
        button.tintColor = Colors.label
        button.layer.cornerRadius = 10
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 14)
        button.setImage(UIImage(systemName: "location.fill", withConfiguration: imageConfiguration), for: .normal)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        return button
    }()

    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animator = MapAnnotationAnimator(mapView: self.mapView)
        view.addSubviews(mapView, locationLabel, userLocationButton)
        mapView.delegate = self

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(centerMapOnLongPressLocation))
        longPressGesture.minimumPressDuration = 0.4
        mapView.addGestureRecognizer(longPressGesture)

        let longPressToCopyGesture = UILongPressGestureRecognizer(target: self, action: #selector(copyLocationFromLocationLabel))
        longPressGesture.minimumPressDuration = 0.3
        locationLabel.addGestureRecognizer(longPressToCopyGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deselectPoint))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(openSheet), name: Notification.Name("TabBarSearchTapped"), object: nil)

        setupConstraints()
        viewModel.fetchUserSavedPoints {
            self.showUserCustomPins()
        }
        setupErrorHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            userLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            userLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userLocationButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            userLocationButton.widthAnchor.constraint(equalToConstant: 33),
        ])
    }

    private func setupErrorHandling() {
        viewModel.errorHandler = { error in
            self.displayNotificationToUser(title: String(localized: "Error"), text: "\(error.localizedDescription)", prefferedStyle: .alert, action: nil)
        }
    }

    // MARK: MKMapView methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let mapAnnotation = annotation as! MapAnnotation
        let identifier = NSStringFromClass(MapAnnotation.self)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        create(annotationView: &annotationView, for: mapAnnotation)
        configure(annotationView: &annotationView, for: mapAnnotation)
        return annotationView
    }

    private func create(annotationView: inout MKAnnotationView?, for annotation: MapAnnotation) {
        let identifier = NSStringFromClass(MapAnnotation.self)
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = false
    }

    private func configure(annotationView: inout MKAnnotationView?, for annotation: MapAnnotation) {
        guard let annotationView = annotationView else {
            return
        }
        if annotation.isUserLocation {
            annotationView.image = UIImage(named: "userLocation")
            annotationView.frame.size = CGSize(width: 20, height: 20)
        } else if annotation.isSaved {
            annotationView.image = UIImage(named: "greenPin")
            annotationView.frame.size = CGSize(width: 30, height: 30)
        } else {
            annotationView.image = UIImage(named: "orangePin")
            annotationView.frame.size = CGSize(width: 30, height: 30)
        }
        annotationView.configureContactShadow()
    }

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        self.displayNotificationToUser(title: String(localized: "Error while loading a map"), text: "\(error.localizedDescription)", prefferedStyle: .alert, action: nil)
    }

    // MARK: Did select annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        let annotation = view.annotation as! MapAnnotation
        showCalloutView(for: annotation, with: view)
        self.resolveLocationLabel(at: annotation.location)
    }

    // MARK: Did deselect annotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        animator.hideCallout(for: view) {
        }
    }

    private func showCalloutView(for annotation: MapAnnotation, with annotationView: MKAnnotationView) {
        let calloutView = CustomCallout.getRespectiveCallout(for: annotation)
        calloutView.delegate = self
        annotationView.addSubview(calloutView)
        calloutView.bottomAnchor.constraint(equalTo: annotationView.topAnchor).isActive = true
        calloutView.centerXAnchor.constraint(equalTo: annotationView.centerXAnchor).isActive = true
        mapView.setCenter(annotation.coordinate, animated: true)
        animator.show(calloutView)
    }

    // MARK: Show user's pins
    private func showUserCustomPins() {
        let savedPoints = viewModel.getUserSavedPoints()
        mapView.addAnnotations(savedPoints)
    }

    private func createUserLocationPin(for location: CLLocation) {
        let mapAnnotation = MapAnnotation(title: "You're here", uid: UUID(), coordinate: location.coordinate, isUserLocation: true, isSaved: false)
        viewModel.setCurrentUserLocation(using: mapAnnotation)
        addMapPin(for: mapAnnotation, span: 0.03)
    }

    // MARK: Add map pin
    private func addMapPin(for annotation: MapAnnotation, span: CGFloat) {
        let region = mapView.createRegion(for: annotation.location, with: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        resolveLocationLabel(at: annotation.location)
    }

    // MARK: Center map on long press
    @objc func centerMapOnLongPressLocation(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            selectionHapticGenerator.selectionChanged()
            let touchpoint = gestureRecognizer.location(in: mapView)
            let wayCoords = mapView.convert(touchpoint, toCoordinateFrom: mapView)
            let span = mapView.region.span
            let pin = MapAnnotation(title: "Custom point", uid: UUID(), coordinate: wayCoords, isUserLocation: false, isSaved: false)
            addMapPin(for: pin, span: span.longitudeDelta)
        default: break
        }
    }

    @objc func deselectPoint(_ sender: UITapGestureRecognizer) {
        let annotations = mapView.selectedAnnotations
        _ = annotations.map { selectedAnnotation in
            self.mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
        self.locationLabel.hideFromUser(animated: true)
    }

    @objc func copyLocationFromLocationLabel(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let locationAdress = self.locationLabel.getLocationName()
            self.locationLabel.showCopiedTextAnimation()
            self.locationLabel.isUserInteractionEnabled = false
            self.notificationHapticGenerator.notificationOccurred(.success)
            UIPasteboard.general.string = locationAdress
        } else if sender.state == .ended {
            self.locationLabel.isUserInteractionEnabled = true
        }
    }

    // MARK: Open Sheet
    @objc func openSheet() {
        let savedPoints = viewModel.getUserSavedPoints()
        let sheetController = SheetVC(userCustomPins: savedPoints)
        sheetController.delegate = self
        sheetController.popularPlacesTableView.calloutDelegate = self
        sheetController.popularPlacesTableView.mapDelegate = self
        sheetController.coordinatesView.delegate = self
        if let sheet = sheetController.sheetPresentationController {
            sheet.detents = savedPoints.isEmpty ? [.medium()] : [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 24.0
        }
        self.present(sheetController, animated: true, completion: nil)
    }

    // MARK: Center map on user location
    @objc func centerMapOnUserLocation() {
        LocationManager.shared.getUserLocation { [weak self] location in
            guard let previousUserLocation = self?.viewModel.getUserLocation() else {
                self?.createUserLocationPin(for: location)
                return
            }
            self?.animator.movePin(pin: previousUserLocation, to: location)
        }
    }
}

// MARK: Display adress of currently focused location
extension CoordinatesVC {
    private func resolveLocationLabel(at location: CLLocation) {
        LocationManager.shared.resolveLocationName(with: location) { locationName in
            guard let locationName = locationName else {
                self.locationLabel.hideFromUser(animated: true)
                return
            }
            self.locationLabel.setNewLocationName(locationName, animated: !self.locationLabel.isHidden)

            if self.locationLabel.isHidden {
                self.locationLabel.showToUser(animated: true)
            }
        }
    }
}

extension CoordinatesVC: MapData {

    // MARK: Center map on new location
    @objc public func centerMapOnNewLocation(location: CLLocation, locationName: String) {
        let mapAnnotation = MapAnnotation(title: "Custom point", uid: UUID(), coordinate: location.coordinate, isUserLocation: false, isSaved: false)
        addMapPin(for: mapAnnotation, span: 0.6)
    }

    // MARK: Center map on saved point
    func centerMapOnSavedPoint(annotation: MapAnnotation) {
        mapView.centerMapOnLocation(annotation.location, span: 0.02) {
            self.resolveLocationLabel(at: annotation.location)
            self.animator.animateFocusOn(annotation: annotation)
        }
    }
}

extension CoordinatesVC: CalloutResponder {

    // MARK: Save user custom point
    func calloutAddButtonTapped(annotation: MKAnnotation) {
        let alertController = UIAlertController(title: String(localized: "Enter a name for your custom point"),
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: String(localized: "Save"), style: .default, handler: { [weak alertController] _ in

            let annotation = annotation as! MapAnnotation
            annotation.title = alertController?.textFields?[0].text

            self.viewModel.saveUserPoint(for: annotation) { savedAnnotation in
                self.mapView.deselectAnnotation(annotation, animated: true)

                if annotation.isUserLocation {
                    self.addMapPin(for: savedAnnotation, span: 0.06)
                } else {
                    self.reconfigureAnnotationToSavedState(annotation: savedAnnotation)
                }
            }
        }))
        present(alertController, animated: true)
    }

    // MARK: Delete user custom point
    func calloutDeleteButtonTapped(annotation: MKAnnotation) {
        let alertController = UIAlertController(title: String(localized: "Delete this point?"), message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: String(localized: "Delete"), style: .destructive) { [weak self] _ in
            self?.viewModel.deleteSavedPoint(for: annotation) {
                self?.animator.removeAnnotationFromMapView(annotation: annotation, animated: true)
            }
        })
        present(alertController, animated: true)
    }

    // MARK: Edit user custom point
    func calloutEditButtonTapped(annotation: MapAnnotation, newTitleForAnnotation: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        annotation.title = newTitleForAnnotation
        annotation.managedObject?.setValue(newTitleForAnnotation, forKeyPath: "name")
        appDelegate.saveContext()
    }

    // MARK: Remove annotation
    func removeDeletedAnnotation(annotation: MapAnnotation) {
        viewModel.deleteSavedPoint(for: annotation) {
            self.animator.removeAnnotationFromMapView(annotation: annotation, animated: true)
        }
    }

    private func reconfigureAnnotationToSavedState(annotation: MapAnnotation) {
        let annotationView = self.mapView.view(for: annotation)
        annotationView?.image = UIImage(named: "greenPin")
        annotationView?.frame.size = CGSize(width: 30, height: 30)
        annotationView?.annotation = annotation
        annotationView?.isSelected = false
    }
}

extension CoordinatesVC: UserPlacesListProtocol {
    func didTapYourLocationsLabel() {

    }
}

extension CoordinatesVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view.self else {
            return false
        }
        return !view.isKind(of: MKAnnotationView.self)
    }
}

extension CoordinatesVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        _ = mapView.annotations.map { annotation in
            guard let mapAnnotation = annotation as? MapAnnotation else { return }
            var view = mapView.view(for: mapAnnotation)
            self.configure(annotationView: &view, for: mapAnnotation)
        }
        self.locationLabel.layer.shadowColor = Colors.darkShadow.cgColor
    }
}
