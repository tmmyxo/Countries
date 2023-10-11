//
//  File.swift
//  Countries
//
//  Created by Artem Dolbiiev on 05.10.2023.
//

import Foundation

extension String {
    var capitalizedSentece: String {
        let firstLetter = self.prefix(1).capitalized
        let restOfSentence = self.dropFirst()
        return firstLetter + restOfSentence
    }
}
