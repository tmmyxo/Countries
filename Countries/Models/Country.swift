//
//  Country.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.03.2021.
//

import Foundation
import UIKit

class Country: Codable, Hashable {

    let name: Name
    let cca2: String //international code like "US" for United States or "UK" for United Kingdom
    let capital: [String?]
    let latlng: [Double]
    let area: Float
    var flagImage: UIImage?
    let region: String?
    let subregion: String?
    let currencies: [String : Currency]?
    let languages: [String : String]?

    //describes if it has been selected in CountrySelector
    var isSelected: Bool = true
    
    lazy var widthFixedFlagLink: URL?  = {
        let stringURL = "https://flagcdn.com/w640/\(cca2.lowercased()).png"
        
        if let encodedURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encodedURL)
        } else {
            return nil
        }
    }()

    lazy var heightFixedFlagLink: URL? = {
        let stringURL = "https://flagcdn.com/h240/\(cca2.lowercased()).png"
        if let encodedURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encodedURL)
        } else {
            return nil
        }
    }()

    enum CodingKeys: String, CodingKey {
        case name
        case cca2
        case capital
        case latlng
        case area
        case region
        case subregion
        case currencies
        case languages
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name.official == rhs.name.official
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.official)
    }

}

struct Name: Codable {
    var common: String
    var official: String
    
    enum CodingKeys: String, CodingKey {
        case common
        case official
    }
}

struct Currency: Codable {
    var name: String
}
