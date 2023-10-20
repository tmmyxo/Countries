//
//  MapAnnotationAnimator.swift
//  Countries
//
//  Created by Artem Dolbiev on 24.11.2021.
//

import UIKit
import MapKit

class MapAnnotationAnimator {
    
    var showingAnimationDuration: TimeInterval = 0.8
    var hidingAnimationDuration: TimeInterval = 0.20
    private let mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
    }

    func show(_ calloutView: UIView, completion: @escaping () -> Void = {}) {
        calloutView.alpha = 0
        calloutView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.showingAnimationDuration, 
                           delay: 0, usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction, .curveEaseOut],
                           animations: {

                calloutView.alpha = 1
                calloutView.transform = .identity

            }) { _ in
                completion()
            }
        }
    }
    
    func hide(_ calloutView: UIView, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.hidingAnimationDuration, animations: {
                calloutView.alpha = 0
                calloutView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }, completion: { _ in
                calloutView.removeFromSuperview()
                completion()
            })
        }
    }

    func animateFocusOn(annotation: MapAnnotation) {
        let annotationView = mapView.view(for: annotation)
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.2) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                annotationView?.transform = CGAffineTransform(translationX: 0, y: -30)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                annotationView?.transform = .identity
            }
        }
    }

    func animateAnnotationRemoval(annotationView: MKAnnotationView, completion: @escaping () -> Void = {}) {
        hideCallout(for: annotationView) {
            UIView.animate(withDuration: 0.3) {
                annotationView.transform = CGAffineTransform(translationX: 0, y: -50)
                annotationView.alpha = 0
            } completion: { _ in
                completion()
            }
        }
    }

    func hideCallout(for annotationView: MKAnnotationView, completion: @escaping () -> Void = {}) {
        if let calloutView = annotationView.subviews.first(where: { view in
            return view is UnsavedPointCallout || view is SavedPointCallout })
        {
            hide(calloutView) {
                completion()
            }
        } else {
            completion()
        }
    }

    func movePin(pin: MapAnnotation, to destination: CLLocation) {
        let isPinVisible = mapView.checkIfLocationVisible(location: pin.coordinate)
        if isPinVisible {
            animatePinMove(pin: pin, to: destination)
        } else {
            animatePinPositionChange(pin: pin, to: destination)
        }
    }

    func animatePinMove(pin: MapAnnotation, to destination: CLLocation) {
        UIView.animate(withDuration: 2.0) {
            pin.location = destination
            pin.coordinate = destination.coordinate
        } completion: { _ in
            let region = self.mapView.createRegion(for: destination, with: 0.02)
            self.mapView.setRegion(region, animated: true)
        }
    }

    func animatePinPositionChange(pin: MapAnnotation, to destination: CLLocation) {
        let region = mapView.createRegion(for: destination, with: 0.02)
        self.mapView.setRegion(region, animated: true)
        pin.coordinate = destination.coordinate
    }

    func removeAnnotationFromMapView(annotation: MKAnnotation, animated: Bool) {
        if animated {
            guard let view = mapView.view(for: annotation) else {
                return
            }
            animateAnnotationRemoval(annotationView: view) {
                self.mapView.deselectAnnotation(annotation, animated: false)
                self.mapView.removeAnnotation(annotation)
            }
        } else {
            self.mapView.deselectAnnotation(annotation, animated: false)
            self.mapView.removeAnnotation(annotation)
        }
    }
}
