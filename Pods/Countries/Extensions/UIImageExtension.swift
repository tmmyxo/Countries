//
//  UIImageExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 01.10.2021.
//
import UIKit

extension UIImage {
    func getAspectRatio() -> CGFloat {
        self.size.width / self.size.height
    }
}

public func loadFlagImage(_ url: URL) -> UIImage {
     var image = UIImage()
     if let data = try? Data(contentsOf: url) {
         image = UIImage(data: data)!
     }
     return image
 }
