//
//  VKLoadingView.swift
//  VKFeed
//
//  Created by Nurbek on 27/09/24.
//

import UIKit

final class VKLoadingView: UIView {
    
    private let viewController: UIViewController
    
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: viewController.view.bounds)
        
        setupViews()
    }
    
    
    private func setupViews() {
        addSubview(activityIndicator)
        
        backgroundColor = .secondarySystemBackground
        alpha = 0
        
        activityIndicator.color = .vkPrimary
        activityIndicator.center = center
    }
    
    
    public func showLoadingView() {
        viewController.view.addSubview(self)
        
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: GlobalConstants.AnimationDuration.short) { [weak self] in
            guard let self else { return }
            alpha = 0.75
        }
    }
    
    
    public func dismissLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            activityIndicator.stopAnimating()
            removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
