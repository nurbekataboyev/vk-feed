//
//  VKButton.swift
//  VKFeed
//
//  Created by Nurbek on 01/10/24.
//

import UIKit

class VKButton: UIButton {
    
    init(title: String? = nil, color: UIColor = .white, backgroundColor bgColor: UIColor, textStyle style: UIFont.TextStyle = .headline) {
        super.init(frame: .zero)
        
        setupButton(title: title, color: color, backgroundColor: bgColor, textStyle: style)
    }
    
    
    private func setupButton(title: String?, color: UIColor, backgroundColor bgColor: UIColor, textStyle style: UIFont.TextStyle) {
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = .setFont(style: style, weight: .semibold)
        
        setTitleColor(color, for: .normal)
        tintColor = color
        titleLabel?.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = GlobalConstants.CornerRadius.small
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
