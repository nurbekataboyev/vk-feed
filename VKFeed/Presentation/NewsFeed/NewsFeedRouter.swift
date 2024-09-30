//
//  NewsFeedRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol NewsFeedRouter {
    static func configure() -> UIViewController
    
    func presentPostDetails(_ post: Post)
}

final class NewsFeedRouterImpl: NewsFeedRouter {
    
    private weak var viewController: UIViewController?
    
    static func configure() -> UIViewController {
        let apiService = APIService()
        let keychainService = KeychainService()
        let accessTokenStorage = AccessTokenStorageImpl(keychainService: keychainService)
        let newsFeedRepository = NewsFeedRepositoryImpl(apiService: apiService, accessTokenStorage: accessTokenStorage)
        let fetchNewsFeedUseCase = FetchNewsFeedUseCaseImpl(repository: newsFeedRepository)
        let router = NewsFeedRouterImpl()
        let viewModel = NewsFeedViewModelImpl(fetchNewsFeedUseCase: fetchNewsFeedUseCase, router: router)
        let newsFeed = NewsFeedViewController(viewModel: viewModel)
        
        router.viewController = newsFeed
        
        return newsFeed
    }
    
    
    public func presentPostDetails(_ post: Post) {
        let postDetails = PostDetailsRouterImpl.configure(with: post)
        viewController?.present(UINavigationController(rootViewController: postDetails), animated: true)
    }
    
}
