//
//  CountryViewModel.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 24.09.2021.
//

import Foundation

class CountryViewModel {
    var countries = [Country]()
    var countriesForGame = [Country]()
    var filteredCountries: [Country] = []
    
    final func getJSONData() {
        guard let path = Bundle.main.path(forResource: "countriesOfTheEarth", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        do {
            countries = try decoder.decode([Country].self, from: json)
        } catch {
            print(error)
        }
    }
    
    final func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            return country.name.common.lowercased().contains(searchText.lowercased())
        })
    }
    
    final func selectThreeRandomCountries() {
        countriesForGame = [Country]()
        guard let selectedCountries = UserDefaults.standard.array(forKey: "selectedCountries") as? [String] else { return }
        var threeCountries = Set<String>()
        
        while threeCountries.count != 3 {
            let randomCountry = selectedCountries.randomElement()
            threeCountries.insert(randomCountry!)
        }
        
        for country in countries {
            if threeCountries.contains(country.name.common) {
                countriesForGame.append(country)
            }
        }
    }
}
