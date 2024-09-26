//
//  VKLabel.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

class VKLabel: UILabel {
    
    init(alignment: NSTextAlignment = .left, style: UIFont.TextStyle, weight: UIFont.Weight = .regular, color: UIColor = .label) {
        super.init(frame: .zero)
        
        setupLabel(alignment: alignment, style: style, weight: weight, color: color)
    }
    
    
    private func setupLabel(alignment: NSTextAlignment, style: UIFont.TextStyle, weight: UIFont.Weight, color: UIColor) {
        textAlignment = alignment
        font = .setFont(style: style, weight: weight)
        textColor = color
        
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
