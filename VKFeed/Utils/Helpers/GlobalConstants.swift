//
//  GlobalConstants.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

struct GlobalConstants {
    
    struct Screen {
        static let width: CGFloat = UIScreen.main.bounds.width
        static let height: CGFloat = UIScreen.main.bounds.height
    }
    
    
    struct Padding {
        static let tiny: CGFloat = 5
        static let small: CGFloat = 10
        static let medium: CGFloat = 15
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 25
        
        static let padding: CGFloat = 18
    }
    
    
    struct CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 15
    }
    
    
    struct AnimationDuration {
        static let extraShort: TimeInterval = 0.1
        static let short: TimeInterval = 0.25
        static let medium: TimeInterval = 0.5
        static let long: TimeInterval = 1.0
    }
    
}
