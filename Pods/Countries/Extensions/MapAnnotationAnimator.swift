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
    var selectingPinAnimationDuration: TimeInterval = 0.3
    var deselectingPinAnimationDuration: TimeInterval = 0.15
    
    func show(_ calloutView: UIView) {
        calloutView.alpha = 0
        
        let calloutFrameBeforeAnimation = calloutView.frame
        
        
        calloutView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        DispatchQueue.main.async {
//            calloutView.frame.height = calloutFrameBeforeAnimation.frame.height / 3
            UIView.animate(withDuration: self.showingAnimationDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                
                calloutView.alpha = 1
//                calloutView.frame = calloutFrameBeforeAnimation
                calloutView.transform = .identity
            })
        }
        
    }
    
    func hide(_ calloutView: UIView) {
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: self.hidingAnimationDuration, animations: {
                calloutView.alpha = 0
//                calloutView.frame.origin = CGPoint(x: calloutView.frame.origin.x, y: calloutView.frame.origin.y)
                calloutView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }, completion: { _ in calloutView.removeFromSuperview()})
        }
    }
    
}
