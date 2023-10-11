//
//  DetailsViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit
import MapKit

class CountryDetailsVC: UIViewController, UIScrollViewDelegate {
    
    var country: Country!
    var countryCoordinates: CLLocation {
        return CLLocation(latitude: country.latlng[0], longitude: country.latlng[1])
    }
    var flagImage: UIImage {
        loadFlagImage(country.widthFixedFlagLink)
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        scroll.backgroundColor = .secondarySystemBackground
        return scroll
    }()
    
    lazy var flagViewBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    } ()
    
    lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .label
        label.sizeToFit()
        return label
    }()
    
    lazy var flagView: FlagView = {
        let countryFlagView = FlagView(flagImage: flagImage)
        countryFlagView.translatesAutoresizingMaskIntoConstraints = false
        return countryFlagView
    }()
    
    lazy var detailView1: DetailView = {
        let officialNameView = DetailView(description: "Official Name", detailText: country.name.official)
        officialNameView.translatesAutoresizingMaskIntoConstraints = false
        return officialNameView
    }()
    lazy var detailView2: DetailView = {
        let countryCodeView = DetailView(description: "Code", detailText: country.cca2)
        countryCodeView.translatesAutoresizingMaskIntoConstraints = false
        return countryCodeView
    }()
    
    lazy var detailView3: DetailView = {
        
        let capitalView = DetailView(description: "Capital", detailText: (country.capital.first ?? "None") ?? "None")
        capitalView.translatesAutoresizingMaskIntoConstraints = false
        return capitalView
    }()
    
    lazy var detailView4: DetailView = {
        let countryAreaView = DetailView(description: "Area", detailText: "\(Int(country.area)) km")
        countryAreaView.translatesAutoresizingMaskIntoConstraints = false
        return countryAreaView
    }()
    
    lazy var detailView5: CoordinatesView = {
        let coordinatesView = CoordinatesView(latitude: country.latlng[0], longitude: country.latlng[1])
        coordinatesView.translatesAutoresizingMaskIntoConstraints = false
        return coordinatesView
    }()
    
    lazy var mapView: MapView = {
        let countryMapView = MapView(coordinates: countryCoordinates, countryArea: country.area)
        countryMapView.translatesAutoresizingMaskIntoConstraints = false
        return countryMapView
    }()
    
    private func setupConstraints() {
        let scrollArea = scrollView.readableContentGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
    
            flagViewBackground.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -10),
            flagViewBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            flagViewBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            flagViewBackground.bottomAnchor.constraint(equalTo: flagView.bottomAnchor, constant: 20),
            
            countryNameLabel.topAnchor.constraint(equalTo: flagViewBackground.topAnchor, constant: 20),
            countryNameLabel.leadingAnchor.constraint(equalTo: flagViewBackground.leadingAnchor, constant: 15),
            countryNameLabel.trailingAnchor.constraint(equalTo: flagViewBackground.trailingAnchor, constant:  -15),
            
            flagView.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 20),
            flagView.centerXAnchor.constraint(equalTo: flagViewBackground.centerXAnchor),
            flagView.widthAnchor.constraint(equalTo: flagViewBackground.widthAnchor, constant: -30),
            flagView.heightAnchor.constraint(equalTo: flagView.widthAnchor, multiplier: 1/flagImage.getAspectRatio()),
            
            detailView1.topAnchor.constraint(equalTo: flagViewBackground.bottomAnchor, constant: 20),
            detailView1.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            detailView1.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            detailView1.heightAnchor.constraint(equalToConstant: 80),
            
            detailView2.topAnchor.constraint(equalTo: detailView1.bottomAnchor, constant: 15),
            detailView2.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            detailView2.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            detailView2.heightAnchor.constraint(equalToConstant: 80),
            
            detailView3.topAnchor.constraint(equalTo: detailView2.bottomAnchor, constant: 15),
            detailView3.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            detailView3.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            detailView3.heightAnchor.constraint(equalToConstant: 80),
            
            detailView4.topAnchor.constraint(equalTo: detailView3.bottomAnchor, constant: 15),
            detailView4.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            detailView4.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            detailView4.heightAnchor.constraint(equalToConstant: 80),
            
            detailView5.topAnchor.constraint(equalTo: detailView4.bottomAnchor, constant: 15),
            detailView5.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            detailView5.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            detailView5.heightAnchor.constraint(equalToConstant: 80),
            
            mapView.topAnchor.constraint(equalTo: detailView5.bottomAnchor, constant: 15),
            mapView.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            mapView.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, constant: -15),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
        
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubviews(flagViewBackground, detailView1, detailView2, detailView3, detailView4, detailView5, mapView)
        flagViewBackground.addSubviews(countryNameLabel, flagView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "WiKi", style: .plain, target: self, action: #selector(openWikipedia))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        scrollView.showsVerticalScrollIndicator = false
        countryNameLabel.text = country.name.common
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @objc func openWikipedia() {
        let wikiWebView = WikiWebVC()
        DispatchQueue.global().async {
            let spacelessCountryName = self.country.name.official.replacingOccurrences(of: " ", with: "_")
            let wikipediaLink = "https://en.wikipedia.org/wiki/"
            wikiWebView.url = URL(string: wikipediaLink + spacelessCountryName)
        }
        DispatchQueue.main.async {
            self.present(wikiWebView, animated: true)
        }
    }
}
