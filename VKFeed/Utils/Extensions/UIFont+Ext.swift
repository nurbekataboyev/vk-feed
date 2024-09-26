//
//  UIFont+Ext.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

extension UIFont {
    
    class func setFont(style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let dynamicSize = descriptor.pointSize
        let fontToScale: UIFont = UIFont.systemFont(ofSize: dynamicSize, weight: weight)
        return metrics.scaledFont(for: fontToScale)
    }
    
}
