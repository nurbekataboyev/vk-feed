//
//  AuthenticationUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol AuthenticationUseCase {
    func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<AuthenticationResponse, Error>
    func saveAccessToken(_ token: String)
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    public func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<AuthenticationResponse, Error> {
        return repository.exchangeCodeForToken(code, deviceID: deviceID, codeVerifier: codeVerifier)
    }
    
    
    public func saveAccessToken(_ token: String) {
        repository.saveAccessToken(token)
    }
    
}
