//
//  UICollectionView+Ext.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
