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
        let apiService = APIService()
        let keychainService = KeychainServiceImpl()
        let tokenStorage = TokenStorageImpl(keychainService: keychainService)
        let tokenRepository = TokenRepositoryImpl(apiService: apiService, tokenStorage: tokenStorage)
        let tokenManager = TokenManagerImpl(tokenRepository: tokenRepository)
        let postRepository = PostRepositoryImpl(apiService: apiService, tokenManager: tokenManager)
        let postLikeUseCase = PostLikeUseCaseImpl(postRepository: postRepository)
        let router = PostDetailsRouterImpl()
        let viewModel = PostDetailsViewModelImpl(post: post, postLikeUseCase: postLikeUseCase, router: router)
        let postDetails = PostDetailsViewController(post, viewModel: viewModel)
        
        router.viewController = postDetails
        
        return postDetails
    }
    
    
    public func close() {
        viewController?.dismiss(animated: true)
    }
    
}
