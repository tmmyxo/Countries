//
//  Service.swift
//  Countries
//
//  Created by Artem Dolbiiev on 11.09.2023.
//

import Foundation

class CountriesService {

    static var shared = CountriesService()

    final func getCountriesData(completion: @escaping ([Country]) -> Void) {

        guard let path = Bundle.main.path(forResource: "Countries", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            parse(json: data) { countries in
                completion(countries)
            }
            return
        }
    }

    private func parse(json: Data, completion: @escaping ([Country]) -> Void) {
        let decoder = JSONDecoder()
        do {
            let countries = try decoder.decode([Country].self, from: json)
            completion(countries)
        } catch {
            print(error)
        }
    }

    final func downloadFlagImages(for countries: [Country], completion: @escaping (Result<[Country], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        for country in countries {
            print("link \(country.heightFixedFlagLink!), country: \(country.name.common)")
            dispatchGroup.enter()
            loadImage(country.heightFixedFlagLink!) { result in
                switch result {
                case .success(let image):
                    dispatchGroup.leave()
                    country.flagImage = image
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(countries))
        }
    }
}
