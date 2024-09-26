//
//  LoginViewModel.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

protocol LoginViewModel {
    func saveAccessToken(_ token: String)
}

final class LoginViewModelImpl: LoginViewModel {
    
    @Published private(set) var isLoggedIn: Bool = false
    
    private let authenticationUseCase: AuthenticationUseCase
    private let router: LoginRouter
    
    init(authenticationUseCase: AuthenticationUseCase,
         router: LoginRouter) {
        self.authenticationUseCase = authenticationUseCase
        self.router = router
    }
    
    public func saveAccessToken(_ token: String) {
        authenticationUseCase.saveAccessToken(token)
        router.navigateToNewsFeed()
    }
    
}
