//
//  CountryViewModel.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 24.09.2021.
//

import UIKit

typealias CountryToGuess = String

class GameViewModel {
    var errorHandler: ((Error) -> Void)?

    private var selectedCountries = [Country]()
    private var countriesForGame = [Country]()
    private var countriesForNextGame = [Country]()
    private var countryToGuess = String()

    var score: Observable<Int> = Observable(0)
    var questionsAnswered: Int = 0

    init(selectedCountries: [Country]) {
        self.selectedCountries = selectedCountries
    }

    func startNewGame(completion: @escaping ([Country], CountryToGuess) -> Void) {
        countriesForGame = getThreeRandomCountries()
        countriesForNextGame = getThreeRandomCountries()

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        downloadFlagsForSelectedCountries(for: countriesForGame) { countriesWithFlags in
            self.countriesForGame = countriesWithFlags
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        downloadFlagsForSelectedCountries(for: countriesForNextGame) { countriesWithFlags in
            self.countriesForNextGame = countriesWithFlags
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.chooseCountryToGuess()
            completion(self.countriesForGame, self.countryToGuess)
        }
    }

    func startNextRound(completion: @escaping ([Country], CountryToGuess) -> Void) {
        countriesForGame = countriesForNextGame
        countriesForNextGame = getThreeRandomCountries()
        downloadFlagsForSelectedCountries(for: countriesForNextGame) { countriesWithFlags in
            self.countriesForNextGame = countriesWithFlags
        }
        chooseCountryToGuess()
        completion(countriesForGame, self.countryToGuess)
    }

    func getCurrentCountries() -> [Country] {
        return countriesForGame
    }

    func isSelectedCountryRight(at index: Int) -> Bool {
        let chosenCountry = countriesForGame[index]
        questionsAnswered += 1
        return chosenCountry.name.common == self.countryToGuess
    }

    private func chooseCountryToGuess() {
        countryToGuess = countriesForGame.randomElement()!.name.common
    }

    private final func getThreeRandomCountries() -> [Country] {
        var threeCountries = Set<Country>()

        while threeCountries.count != 3 {
            let randomCountry = selectedCountries.randomElement()

            if countriesForGame.contains(randomCountry!) {
                continue
            } else {
                threeCountries.insert(randomCountry!)
            }
        }
        return Array(threeCountries)
    }

    private func downloadFlagsForSelectedCountries(for countries: [Country], completion: @escaping ([Country]) -> Void) {
        CountriesService.shared.downloadFlagImages(for: countries) { result in
            switch result {
            case .success(let countriesWithFlagImages):
                completion(countriesWithFlagImages)
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }

    func increaseScore() {
        score.value += 1
    }

    func saveScore() {
        guard let highScore = UserDefaults.standard.value(forKey: "highscore") as? Int else { return }
        if score.value > highScore {
            UserDefaults.standard.set(score.value, forKey: "highscore")
        }
    }
}
