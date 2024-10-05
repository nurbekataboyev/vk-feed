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
    func logout() -> AnyPublisher<Void, Error>
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let authenticationRepository: AuthenticationRepository
    private let userRepository: UserRepository
    
    init(authenticationRepository: AuthenticationRepository,
         userRepository: UserRepository) {
        self.authenticationRepository = authenticationRepository
        self.userRepository = userRepository
    }
    
    public func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<AuthenticationResponse, Error> {
        return authenticationRepository.exchangeCodeForToken(code, deviceID: deviceID, codeVerifier: codeVerifier)
    }
    
    
    public func saveAccessToken(_ token: String, expiresIn: Int) {
        authenticationRepository.saveAccessToken(token, expiresIn: expiresIn)
    }
    
    
    public func logout() -> AnyPublisher<Void, Error> {
        return authenticationRepository.invalidateAccessToken()
            .flatMap { [weak self] response -> AnyPublisher<Void, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                if response.isInvalidated {
                    authenticationRepository.clearAccessToken()
                    userRepository.clearUser()
                    
                    return Just(()).setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher()
                }
                
            }
            .eraseToAnyPublisher()
    }
    
}
