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
        let keychainService = KeychainServiceImpl()
        let apiService = APIService()
        let tokenStorage = TokenStorageImpl(keychainService: keychainService)
        let tokenRepository = TokenRepositoryImpl(apiService: apiService, tokenStorage: tokenStorage)
        let tokenManager = TokenManagerImpl(tokenRepository: tokenRepository)
        let authenticationRepository = AuthenticationRepositoryImpl(apiService: apiService, tokenManager: tokenManager)
        let userDefaultsService = UserDefaultsServiceImpl()
        let userStorage = UserStorageImpl(userDefaultsService: userDefaultsService)
        let userRepository = UserRepositoryImpl(apiService: apiService, userStorage: userStorage, tokenManager: tokenManager)
        let authenticationUseCase = AuthenticationUseCaseImpl(authenticationRepository: authenticationRepository, tokenRepository: tokenRepository, userRepository: userRepository)
        let userUseCase = UserUseCaseImpl(userRepository: userRepository)
        let router = LoginRouterImpl()
        let viewModel = LoginViewModelImpl(authenticationUseCase: authenticationUseCase, userUseCase: userUseCase, router: router)
        let login = LoginViewController(viewModel: viewModel)
        
        router.viewController = login
        
        return login
    }
    
    
    public func setNewsFeed() {
        let newsFeedViewController = NewsFeedRouterImpl.configure()
        viewController?.navigationController?.setViewControllers([newsFeedViewController], animated: true)
    }
    
}
