//
//  CountrySelectorVM.swift
//  Countries
//
//  Created by Artem Dolbiiev on 12.09.2023.
//

import Foundation

class CountrySelectorVM {

    private var countries: [Country]

    var selectionStatus: Bool = true

    init(countries: [Country]) {
        self.countries = countries
    }

    func toggleAllCountriesSelectionStatus() {
        selectionStatus.toggle()
        for index in 0..<countries.count {
            countries[index].isSelected = selectionStatus
        }
    }

    func saveSelection() {
        let selectedCountries = countries.filter{$0.isSelected}.map{$0.name.common}
        UserDefaults.standard.set(selectedCountries, forKey: "selectedCountries")
    }

    func getCountries() -> [Country] {
        return countries
    }

    func getCountry(at index: Int) -> Country {
        return countries[index]
    }

    func getCountriesCount() -> Int {
        return countries.count
    }

    func changeCountrySelectionStatus(at index: Int) {
        countries[index].isSelected.toggle()
    }

}
