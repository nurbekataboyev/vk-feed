//
//  VKImageView.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

class VKImageView: UIImageView {
    
    init(contentMode mode: UIView.ContentMode) {
        super.init(frame: .zero)
        
        setupImageView(contentMode: mode)
    }
    
    
    private func setupImageView(contentMode mode: UIView.ContentMode) {
        contentMode = mode
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
