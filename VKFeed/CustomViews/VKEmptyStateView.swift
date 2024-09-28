//
//  VKEmptyStateView.swift
//  VKFeed
//
//  Created by Nurbek on 28/09/24.
//

import UIKit
import SnapKit

final class VKEmptyStateView: UIView {
    
    private let viewController: UIViewController
    
    private var imageView = VKImageView(contentMode: .scaleAspectFill)
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: viewController.view.bounds)
        
        setupViews()
        layout()
    }
    
    
    private func setupViews() {
        addSubview(imageView)
        
        backgroundColor = .systemBackground
        alpha = 0
    }
    
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
    }
    
    
    public func showEmptyState(with image: UIImage?, color: UIColor? = .vkPrimary) {
        viewController.view.addSubview(self)
        
        imageView.image = image
        imageView.tintColor = color
        
        UIView.animate(withDuration: GlobalConstants.AnimationDuration.short) { [weak self] in
            guard let self else { return }
            alpha = 1
        }
    }
    
    
    public func dismissEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
