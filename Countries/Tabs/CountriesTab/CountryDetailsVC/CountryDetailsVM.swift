//
//  CountryDetailsVM.swift
//  Countries
//
//  Created by Artem Dolbiiev on 03.10.2023.
//

import UIKit.UIImage
import CoreLocation.CLLocation

class CountryDetailsViewModel {

    var errorHandler: ((Error) -> Void)?

    let country: Country

    var countryCoordinates: CLLocation {
        return CLLocation(latitude: country.latlng[0], longitude: country.latlng[1])
    }

    init(country: Country) {
        self.country = country
    }

    func wikipediaLink() -> URL? {
        let locale = Locale.current.language.languageCode!.identifier
        let spacelessCountryName = country.name.common.replacingOccurrences(of: " ", with: "_")
        let wikipediaLink = "https://\(locale).wikipedia.org/wiki/"
        let urlString = wikipediaLink + spacelessCountryName
        if let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encodedURL)
        } else {
            return nil
        }
    }

    func getListOfLanguages() -> String {
        guard let languages = country.languages?.values, languages.isEmpty != true else {
            return String(localized: "None")
        }
        let capitalizedLanguages = languages.map { $0.capitalizedSentece }
        let languagesJoinedString = capitalizedLanguages.joined(separator: "\n")
        return languagesJoinedString
    }

    func getListOfCurrencies() -> String {
        guard let currencies = country.currencies?.values, currencies.isEmpty != true else {
            return String(localized: "None")
        }
        let currenciesNames = currencies.compactMap { $0.name.capitalized.capitalizedSentece }
        let currenciesList = currenciesNames.joined(separator: "\n")
        return currenciesList
    }

    func getRegion() -> String {
        guard let region = country.region, region.isEmpty != true else {
            return String(localized: "None").capitalized
        }
        return region
    }

    func getSubregion() -> String {
        guard let region = country.subregion, region.isEmpty != true else {
            return String(localized: "None").capitalized
        }
        return region
    }

    func getCapital() -> String {
        guard let capital = country.capital.compactMap({$0}).first, capital.isEmpty != true else {
            return String(localized: "None").capitalized
        }
        return capital
    }

    func getLongitude() -> String {
        let longitude = country.latlng[0]
        return String(longitude)
    }

    func getLatitude() -> String {
        let latitude = country.latlng[1]
        return String(latitude)
    }

    func getCCA2Code() -> String {
        return country.cca2
    }

    func getCountryArea() -> String {
        let area = Int(country.area)
        return String(localized: ("\(area) km"))
    }

    func getCountryFlag(completion: @escaping (UIImage) -> Void) {
        loadImage(self.country.widthFixedFlagLink!) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
}
