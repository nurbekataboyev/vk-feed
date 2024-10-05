//
//  NewsFeedRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol NewsFeedRouter {
    static func configure() -> UIViewController
    
    func setLogin()
    func presentPostDetails(_ post: Post)
}

final class NewsFeedRouterImpl: NewsFeedRouter {
    
    private weak var viewController: UIViewController?
    
    static func configure() -> UIViewController {
        let apiService = APIService()
        let keychainService = KeychainService()
        let accessTokenStorage = AccessTokenStorageImpl(keychainService: keychainService)
        let newsFeedRepository = NewsFeedRepositoryImpl(apiService: apiService, accessTokenStorage: accessTokenStorage)
        let newsFeedUseCase = NewsFeedUseCaseImpl(newsFeedRepository: newsFeedRepository)
        let authenticationRepository = AuthenticationRepositoryImpl(apiService: apiService, accessTokenStorage: accessTokenStorage)
        let logoutUseCase = LogoutUseCaseImpl(authenticationRepository: authenticationRepository)
        let router = NewsFeedRouterImpl()
        let viewModel = NewsFeedViewModelImpl(newsFeedUseCase: newsFeedUseCase, logoutUseCase: logoutUseCase, router: router)
        let newsFeed = NewsFeedViewController(viewModel: viewModel)
        
        router.viewController = newsFeed
        
        return newsFeed
    }
    
    
    public func setLogin() {
        let login = LoginRouterImpl.configure()
        viewController?.navigationController?.setViewControllers([login], animated: true)
    }
    
    
    public func presentPostDetails(_ post: Post) {
        let postDetails = PostDetailsRouterImpl.configure(with: post)
        
        if let postDetails = postDetails as? PostDetailsViewController {
            postDetails.delegate = viewController as? NewsFeedViewController
        }
        
        viewController?.present(UINavigationController(rootViewController: postDetails), animated: true)
    }
    
}
