//
//  AnnotationView.swift
//  Countries
//
//  Created by Artem Dolbiev on 13.11.2021.
//

import MapKit

class AnnotationView: MKAnnotationView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if !isInside {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    
    
    
    
    
    
    
    
    
//    let detailView = DetailCalloutView()
//    let rightView = RightCalloutView()
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        self.markerTintColor = .systemBlue
//        canShowCallout = true
//        self.sizeToFit()
//        setupAnnotationView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//    func setupAnnotationView() {
//        NSLayoutConstraint.activate([
//            rightView.widthAnchor.constraint(equalToConstant: 50),
//            rightView.heightAnchor.constraint(equalToConstant: 110),
//            detailView.heightAnchor.constraint(equalToConstant: 110),
//            detailView.widthAnchor.constraint(equalToConstant: 200),
//        ])
//
//        detailCalloutAccessoryView = detailView
//        rightCalloutAccessoryView = rightView
//
//        print("configuring AnnotationView")
//    }
}
