//
//  CalloutWrapper.swift
//  Countries
//
//  Created by Artem Dolbiiev on 11.09.2023.
//

import UIKit

class CalloutWrapper: UIView {

    init(annotation: MapAnnotation) {
        if annotation.isSaved {
            self = SavedPointCallout(annotation: annotation)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
