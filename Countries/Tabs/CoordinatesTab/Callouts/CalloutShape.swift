//
//  CalloutShape.swift
//  Countries
//
//  Created by Artem Dolbiiev on 18.10.2023.
//

import UIKit

class CalloutShape: CAShapeLayer {

    init(for customCallout: CustomCallout) {
        super.init()

        let rect = customCallout.bounds
        let annotationSize = customCallout.annotationViewSize
        let cornerRadius = customCallout.cornerRadius
        let path = UIBezierPath()

        // lower left corner
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - annotationSize))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - annotationSize - cornerRadius), controlPoint: CGPoint(x: rect.minX, y: rect.maxY - annotationSize))

        // left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        // upper left corner
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))

        // top
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

        // upper right corner
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        // right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - annotationSize - cornerRadius))

        // lower right corner
        path.addQuadCurve(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - annotationSize),
                          controlPoint: CGPoint(x: rect.maxX, y: rect.maxY - annotationSize))

        // bottom (including callout)
        path.addLine(to: CGPoint(x: rect.midX + annotationSize, y: rect.maxY - annotationSize))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - annotationSize, y: rect.maxY - annotationSize))
        path.close()

        customCallout.fillColor.setFill()
        path.fill()
        path.close()
        self.path = path.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
