//
//  UIView+Ext.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    
    public func addShadow(withOpacity opacity: Float = 0.125, radius: CGFloat = 2.25, color: CGColor = UIColor.black.cgColor) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color
        layer.shadowOffset = .zero
    }
    
    
    public func makeVibration(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.impactOccurred()
    }
    
}
