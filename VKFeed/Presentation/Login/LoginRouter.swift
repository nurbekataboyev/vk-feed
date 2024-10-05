//
//  LoginRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol LoginRouter {
    static func configure() -> UIViewController
    
    func setNewsFeed()
}

final class LoginRouterImpl: LoginRouter {
    
    private weak var viewController: UIViewController?
    
    static func configure() -> UIViewController {
        let keychainService = KeychainService()
        let apiService = APIService()
        let accessTokenStorage = AccessTokenStorageImpl(keychainService: keychainService)
        let authenticationRepository = AuthenticationRepositoryImpl(apiService: apiService, accessTokenStorage: accessTokenStorage)
        let authenticationUseCase = AuthenticationUseCaseImpl(authenticationRepository: authenticationRepository)
        let router = LoginRouterImpl()
        let viewModel = LoginViewModelImpl(authenticationUseCase: authenticationUseCase, router: router)
        let login = LoginViewController(viewModel: viewModel)
        
        router.viewController = login
        
        return login
    }
    
    
    public func setNewsFeed() {
        let newsFeedViewController = NewsFeedRouterImpl.configure()
        viewController?.navigationController?.setViewControllers([newsFeedViewController], animated: true)
    }
    
}
