//
//  AuthenticationUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol AuthenticationUseCase {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    public func saveAccessToken(_ token: String) {
        repository.saveAccessToken(token)
    }
    
    
    public func getAccessToken() -> String? {
        return repository.getAccessToken()
    }
    
}
