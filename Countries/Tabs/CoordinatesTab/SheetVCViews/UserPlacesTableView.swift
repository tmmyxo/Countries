//
//  PlacesView.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.10.2021.
//

import UIKit
import CoreLocation
import CoreData

protocol UserPlacesListProtocol: NSObject {
    func didTapYourLocationsLabel()
}

class UserPlacesTableView: UIView {

    weak var delegate: UserPlacesListProtocol?
    var mapDelegate: MapData?
    var calloutDelegate: CalloutResponder?
    var userPlaces = [MapAnnotation]() {
        didSet {
            resolveView()
        }
    }

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Saved locations")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.contentMode = .center
        label.textColor = Colors.label
        return label
    }()

    private lazy var noUserPlacesView: UIView = {
        let view = NoUserPlacesPlaceholderCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let tableView: UITableView = {
        let places = UITableView()
        places.translatesAutoresizingMaskIntoConstraints = false
        places.backgroundColor = Colors.backgroundColor
        places.showsVerticalScrollIndicator = false
        places.separatorStyle = .none
        places.layer.cornerRadius = 18
        places.clipsToBounds = true
        return places
    }()

    // MARK: Init
    init() {
        super.init(frame: CGRect.zero)
        tableView.register(PlacesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        setupConstraints()
        setupLabelGestureRecognizer()
        backgroundColor = Colors.backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(descriptionLabel, tableView, noUserPlacesView)
    }

    // MARK: Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),

            tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            noUserPlacesView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            noUserPlacesView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            noUserPlacesView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noUserPlacesView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }

    private func setupLabelGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapYourLocationsLabel))
        tapGestureRecognizer.isEnabled = true
        self.descriptionLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func resolveView() {
        if userPlaces.isEmpty {
            showPlaceholder()
        } else {
            showTableView()
        }
    }

    private func showTableView() {
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.alpha = 1
            self.tableView.alpha = 1
            self.noUserPlacesView.alpha = 0
        } completion: { _ in
            self.descriptionLabel.isHidden = false
            self.tableView.isHidden = false
            self.noUserPlacesView.isHidden = true
        }
    }

    private func showPlaceholder() {
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.alpha = 0
            self.tableView.alpha = 0
            self.noUserPlacesView.alpha = 1
        } completion: { _ in
            self.descriptionLabel.isHidden = true
            self.tableView.isHidden = true
            self.noUserPlacesView.isHidden = false
        }
    }

}

// MARK: TableView methods
extension UserPlacesTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlaces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        let userSavedPlace = userPlaces[indexPath.row]
        cell.placeNameLabel.text = userSavedPlace.title
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = userPlaces[indexPath.row]
        mapDelegate?.centerMapOnSavedPoint(annotation: selectedPlace)
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let savedPoint = userPlaces[indexPath.row]
            calloutDelegate?.removeDeletedAnnotation?(annotation: savedPoint)
            userPlaces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension UserPlacesTableView {
    @objc func didTapYourLocationsLabel() {
        delegate?.didTapYourLocationsLabel()
    }
}
