//
//  SheetViewController.swift
//  Coordinates
//
//  Created by Artem Dolbiev on 21.10.2021.
//

import UIKit
import CoreLocation
import CoreData

typealias CoordinatesSheetDelegate = MapData & CalloutResponder & UserPlacesListProtocol

protocol MapData {
    func centerMapOnNewLocation(location: CLLocation, locationName: String)
    func centerMapOnSavedPoint(annotation: MapAnnotation)
}

class SheetVC: UIViewController {

    weak var delegate: CoordinatesSheetDelegate?

    private lazy var message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        label.textColor = Colors.label
        label.text = String(localized: "Coordinates Navigation")
        label.setContentCompressionResistancePriority(.sceneSizeStayPut, for: .vertical)
        return label
    }()
    
    lazy var coordinatesView: UserCoordinatesView = {
        let view = UserCoordinatesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        return view
    }()
    
    lazy var popularPlacesTableView: UserPlacesTableView = {
        let places = UserPlacesTableView()
        places.translatesAutoresizingMaskIntoConstraints = false
        places.layer.cornerRadius = 18
        places.layer.shadowColor = UIColor.darkGray.cgColor
        places.layer.shadowOpacity = 0.2
        places.layer.shadowRadius = 2
        places.layer.shadowOffset = CGSize(width: 1, height: 1)
        return places
    }()

    init(userCustomPins: [MapAnnotation]) {
        super.init(nibName: nil, bundle: nil)
        popularPlacesTableView.userPlaces = userCustomPins
        popularPlacesTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.secondaryBackground
        loadSubviews()
        addConstraints()
    }
    
    private func loadSubviews() {
        view.addSubviews(message, coordinatesView, popularPlacesTableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            message.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            message.heightAnchor.constraint(equalToConstant: 25),
            message.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            coordinatesView.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 20),
            coordinatesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            coordinatesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            coordinatesView.heightAnchor.constraint(equalToConstant: 190),
            
            popularPlacesTableView.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 15),
            popularPlacesTableView.leadingAnchor.constraint(equalTo: coordinatesView.leadingAnchor),
            popularPlacesTableView.trailingAnchor.constraint(equalTo: coordinatesView.trailingAnchor),
            popularPlacesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
            
        ])
    }
}

extension SheetVC: UserPlacesListProtocol {

    func didTapYourLocationsLabel() {
        guard let sheetViewController = self.presentationController as? UISheetPresentationController else {
            return
        }
        sheetViewController.detents = [.large()]
    }
}
