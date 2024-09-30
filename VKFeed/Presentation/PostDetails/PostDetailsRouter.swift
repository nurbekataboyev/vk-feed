//
//  PostDetailsRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol PostDetailsRouter {
    static func configure(with post: Post) -> UIViewController
    
    func close()
}

final class PostDetailsRouterImpl: PostDetailsRouter {
    
    private weak var viewController: UIViewController?
    
    static func configure(with post: Post) -> UIViewController {
        let router = PostDetailsRouterImpl()
        let viewModel = PostDetailsViewModelImpl(router: router)
        let postDetails = PostDetailsViewController(post, viewModel: viewModel)
        
        router.viewController = postDetails
        
        return postDetails
    }
    
    
    public func close() {
        viewController?.dismiss(animated: true)
    }
    
}
