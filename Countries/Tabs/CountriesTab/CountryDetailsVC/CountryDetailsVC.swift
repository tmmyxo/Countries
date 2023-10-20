//
//  DetailsViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 28.09.2021.
//

import UIKit
import MapKit

class CountryDetailsVC: UIViewController, UIScrollViewDelegate {

    let viewModel: CountryDetailsViewModel

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = Colors.secondaryBackground
        return scroll
    }()

    private var flagView: FlagView!

    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()

    private lazy var countryNameView: DetailView = {
        let countryName = viewModel.country.name.official
        let title = String(localized: "Official Name")
        let officialNameView = DetailView(title: title, text: countryName )
        return officialNameView
    }()

    private lazy var capitalView: DetailView = {
        let title = String(localized: "Capital")
        let capital = viewModel.getCapital()
        let capitalView = DetailView(title: title, text: capital)
        return capitalView
    }()

    private lazy var regionsView: DetailsSplitView = {
        let leftTitle = String(localized: "Region")
        let leftText = viewModel.getRegion()

        let rightTitle = String(localized: "Subregion")
        let rightText = viewModel.getSubregion()

        let codeAndAreaView = DetailsSplitView(
            leftTitle: leftTitle,
            leftText: leftText,
            rightTitle: rightTitle,
            rightText: rightText)
        codeAndAreaView.spacing = 20
        return codeAndAreaView
    }()

    private lazy var currencyAndLanguagesView: DetailsSplitView = {
        let currencies = viewModel.getListOfCurrencies()
        let languages = viewModel.getListOfLanguages()

        let leftTitle = String(localized: "Languages")
        let leftText = languages

        let rightTitle = String(localized: "Currencies")
        let rightText = currencies

        let currencyAndLanguagesView = DetailsSplitView(
            leftTitle: leftTitle,
            leftText: leftText,
            rightTitle: rightTitle,
            rightText: rightText)
        currencyAndLanguagesView.spacing = 20
        return currencyAndLanguagesView
    }()

    private lazy var codeAndAreaView: DetailsSplitView = {
        let leftTitle = String(localized: "Code")
        let leftText = viewModel.getCCA2Code()

        let rightTitle = String(localized: "Area")
        let rightText = viewModel.getCountryArea()

        let codeAndAreaView = DetailsSplitView(
            leftTitle: leftTitle,
            leftText: leftText,
            rightTitle: rightTitle,
            rightText: rightText)
        codeAndAreaView.spacing = 20
        return codeAndAreaView
    }()

    private lazy var coordinatesView: DetailsSplitView = {
        let leftTitle = String(localized: "Longitude")
        let leftText = viewModel.getLongitude()

        let rightTitle = String(localized: "Latitude")
        let rightText = viewModel.getLatitude()

        let coordinatesView = DetailsSplitView(leftTitle: leftTitle, leftText: leftText, rightTitle: rightTitle, rightText: rightText)
        coordinatesView.spacing = 20
        return coordinatesView
    }()

    private lazy var mapView: MapView = {
        let countryMapView = MapView()
        let defaultLocation = CLLocation(latitude: 39, longitude: 34)
        countryMapView.translatesAutoresizingMaskIntoConstraints = false
        countryMapView.showWholeWorld()
        return countryMapView
    }()

    // MARK: Init
    init(country: Country) {
        viewModel = CountryDetailsViewModel(country: country)
        super.init(nibName: nil, bundle: nil)
        setupErrorHandling()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.secondaryBackground
        setupLoadingIndicator()
        setupNavigationBar()
        scrollView.showsVerticalScrollIndicator = false
        viewModel.getCountryFlag() { image in
            self.loadingIndicator.removeFromSuperview()
            self.flagView = self.createFlagView(for: image)
            self.displayScrollView()
        }
    }

    private func createFlagView(for flagImage: UIImage) -> FlagView {
        let view = FlagView(flagImage: flagImage, countryName: viewModel.country.name.common)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = Colors.darkShadow.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }

    private func displayScrollView() {
        setupViews()
        setupConstraints()
    }

    private func setupLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        loadingIndicator.startAnimating()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "WiKi", style: .plain, target: self, action: #selector(openWikipedia))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubviews(flagView, detailsStackView, mapView)
        detailsStackView.addArrangedSubviews(countryNameView, capitalView, currencyAndLanguagesView, regionsView, codeAndAreaView, coordinatesView)
    }

    // MARK: Constraints Setup
    private func setupConstraints() {
        let scrollArea = scrollView.readableContentGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            flagView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            flagView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            flagView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            detailsStackView.topAnchor.constraint(equalTo: flagView.bottomAnchor, constant: 20),
            detailsStackView.leadingAnchor.constraint(equalTo: flagView.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: flagView.trailingAnchor),

            mapView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 20),
            mapView.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            mapView.widthAnchor.constraint(equalTo: flagView.widthAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25)
        ])
    }
}

extension CountryDetailsVC {

    // MARK: Actions
    @objc func openWikipedia() {
        let wikiWebView = WikiWebVC(url: viewModel.wikipediaLink())
        self.present(wikiWebView, animated: true)
    }

    private func setupErrorHandling() {
        viewModel.errorHandler = { error in
            self.displayNotificationToUser(title: String(localized: "Couldn't get data"), text: error.localizedDescription, prefferedStyle: .alert) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension CountryDetailsVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let viewFrame = scrollView.convert(mapView.bounds, from: mapView)
        if viewFrame.intersects(scrollView.bounds) {
            mapView.focusOnLocation(viewModel.countryCoordinates, area: viewModel.country.area, animated: true)
        }
    }
}

extension CountryDetailsVC {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        flagView?.layer.shadowColor = Colors.darkShadow.cgColor
    }
}

#Preview {
    let country = CountriesViewModel().countries[16]
    return CountryDetailsVC(country: country)
}
