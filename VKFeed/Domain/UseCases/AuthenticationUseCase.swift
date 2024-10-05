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
    func saveAccessToken(_ token: String, expiresIn: Int)
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    public func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<AuthenticationResponse, Error> {
        return authenticationRepository.exchangeCodeForToken(code, deviceID: deviceID, codeVerifier: codeVerifier)
    }
    
    
    public func saveAccessToken(_ token: String, expiresIn: Int) {
        authenticationRepository.saveAccessToken(token, expiresIn: expiresIn)
    }
    
}
