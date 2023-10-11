//
//  StartScreenVM.swift
//  Countries
//
//  Created by Artem Dolbiiev on 12.09.2023.
//

import Foundation

class StartScreenVM {

    private var countries = [Country]()

    init() {
        CountriesService.shared.getCountriesData { countries in
            self.countries = countries
            self.loadSelection()
        }
    }

    func loadSelection() {
        guard let selectedCountries = UserDefaults.standard.array(forKey: "selectedCountries") as? [String] else { return }
        for (index, country) in countries.enumerated() {
            countries[index].isSelected = selectedCountries.contains(country.name.common)
        }
    }

    func getCountriesSelectedForGame() -> [Country] {
        let selectedCountries = countries.filter{$0.isSelected}
        return selectedCountries
    }

    func getCountries() -> [Country] {
        return countries
    }

    func updateCountries(with countries: [Country]) {
        self.countries = countries
    }

}
