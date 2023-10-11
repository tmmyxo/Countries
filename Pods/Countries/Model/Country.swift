//
//  Country.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.03.2021.
//

import Foundation
import UIKit

struct Country: Codable {
    var name: name
    var cca2: String //international code like "US" for United States or "UK" for United Kingdom
    var unMember: Bool
    var capital: [String?]
    var latlng: [Double]
    var area: Float
    
    //describes if it has been selected in selector view
    var isSelected: Bool = true
    
    var widthFixedFlagLink: URL {
        return URL(string: "https://flagcdn.com/w640/\(cca2.lowercased()).png")!
    }
    
    var heightFixedFlagLink: URL {
        return URL(string: "https://flagcdn.com/h240/\(cca2.lowercased()).png")!
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case cca2 = "cca2"
        case unMember
        case capital = "capital"
        case latlng
        case area = "area"
    }

}

struct name: Codable {
    var common: String
    var official: String
    
    enum CodingKeys: String, CodingKey {
        case common = "common"
        case official = "official"
    }
}
