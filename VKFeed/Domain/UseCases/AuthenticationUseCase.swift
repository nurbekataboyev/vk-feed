//
//  AuthenticationUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol AuthenticationUseCase {
    func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<Void, Error>
    func logout() -> AnyPublisher<Void, Error>
}

final class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let authenticationRepository: AuthenticationRepository
    private let tokenRepository: TokenRepository
    private let userRepository: UserRepository
    
    init(authenticationRepository: AuthenticationRepository,
         tokenRepository: TokenRepository,
         userRepository: UserRepository) {
        self.authenticationRepository = authenticationRepository
        self.tokenRepository = tokenRepository
        self.userRepository = userRepository
    }
    
    public func authenticate(withCode code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<Void, Error> {
        return authenticationRepository.exchangeCodeForToken(code, deviceID: deviceID, codeVerifier: codeVerifier)
            .flatMap { [weak self] tokenResponse -> AnyPublisher<User, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                tokenRepository.saveTokens(
                    accessToken: tokenResponse.accessToken,
                    refreshToken: tokenResponse.refreshToken,
                    deviceID: deviceID,
                    expiresIn: tokenResponse.expiresIn)
                
                return userRepository.fetchUser()
            }
            .flatMap { [weak self] user -> AnyPublisher<Void, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                userRepository.saveUser(user)
                
                return Just(()).setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    public func logout() -> AnyPublisher<Void, Error> {
        return authenticationRepository.invalidateTokens()
            .flatMap { [weak self] response -> AnyPublisher<Void, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                if response.isInvalidated {
                    tokenRepository.clearTokens()
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
