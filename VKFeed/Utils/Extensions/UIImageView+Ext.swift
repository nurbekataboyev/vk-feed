//
//  UIImageView+Ext.swift
//  VKFeed
//
//  Created by Nurbek on 28/09/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    public func setImage(from URLString: String?, placeholder: UIImage? = nil) {
        guard let URLString, let url = URL(string: URLString) else {
            image = placeholder
            return
        }
        
        kf.setImage(with: url, placeholder: placeholder)
    }
    
}
