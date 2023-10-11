//
//  UIImageExtension.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 01.10.2021.
//
import SDWebImage
import UIKit

extension UIImage {
    func getAspectRatio() -> CGFloat {
        self.size.width / self.size.height
    }

    func withRoundedCorners(cornerRadius: CGFloat) -> UIImage {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        layer.contents = self.cgImage
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous

        let renderer = UIGraphicsImageRenderer(
            bounds: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height),
            format: UIGraphicsImageRendererFormat(for: traitCollection)
        )

        let roundedImage = renderer.image { action in
            layer.render(in: action.cgContext)
        }
//        self.image = roundedImage
        return roundedImage
    }
}

public func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    SDWebImageManager.shared.loadImage(with: url, progress: nil) { downloadedImage, data, error, cache, finished, urlcl in
        if let image = downloadedImage {
            completion(.success(image))
        } else if let unwrappedError = error {
            completion(.failure(unwrappedError))
        } else {
            return
        }
    }
 }


