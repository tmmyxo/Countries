//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Artem Dolbiiev on 11.09.2023.
//

import Foundation

class CountriesViewModel {

    var countries = [Country]()
    var filteredCountries: [Country] = []

    init() {
        CountriesService.shared.getCountriesData { countries in
            let locale = Locale.current
            let sortedCountries = countries.sorted {
                $0.name.common.compare($1.name.common, locale: locale) == .orderedAscending
            }
            self.countries = sortedCountries
        }
    }

    final func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            return country.name.common.lowercased().contains(searchText.lowercased())
        })
    }
}
