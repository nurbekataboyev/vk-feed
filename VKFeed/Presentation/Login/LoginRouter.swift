//
//  LoginRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol LoginRouter {
    static func configure() -> UIViewController
    
    func navigateToNewsFeed()
}

final class LoginRouterImpl: LoginRouter {
    
    private weak var viewController: UIViewController?
    
    static func configure() -> UIViewController {
        let keychainService = KeychainService()
        let accessTokenStorage = AccessTokenStorageImpl(keychainService: keychainService)
        let authRepository = AuthenticationRepositoryImpl(storage: accessTokenStorage)
        let authUseCase = AuthenticationUseCaseImpl(repository: authRepository)
        let router = LoginRouterImpl()
        let viewModel = LoginViewModelImpl(authenticationUseCase: authUseCase, router: router)
        let login = LoginViewController(viewModel: viewModel)
        
        router.viewController = login
        
        return login
    }
    
    
    public func navigateToNewsFeed() {
        let newsFeedViewController = NewsFeedRouterImpl.configure()
        viewController?.navigationController?.setViewControllers([newsFeedViewController], animated: false)
    }
    
}
