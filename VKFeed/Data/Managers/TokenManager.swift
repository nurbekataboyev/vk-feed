//
//  TokenManager.swift
//  VKFeed
//
//  Created by Nurbek on 07/10/24.
//

import Foundation
import Combine

protocol TokenManager {
    func getValidAccessToken() -> AnyPublisher<String, Error>
}

final class TokenManagerImpl: TokenManager {
    
    private let tokenRepository: TokenRepository
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    public func getValidAccessToken() -> AnyPublisher<String, Error> {
        if tokenRepository.isAccessTokenValid(),
           let accessToken = tokenRepository.getAccessToken() {
            return Just(accessToken).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return refreshAndGetAccessToken()
        }
    }
    
}


extension TokenManagerImpl {
    
    private func refreshAndGetAccessToken() -> AnyPublisher<String, Error> {
        return tokenRepository.refreshTokens()
            .flatMap { [weak self] tokenResponse -> AnyPublisher<String, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                tokenRepository.updateTokens(
                    accessToken: tokenResponse.accessToken,
                    refreshToken: tokenResponse.refreshToken,
                    expiresIn: tokenResponse.expiresIn)
                
                return Just(tokenResponse.accessToken).setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .mapError { _ in VKError.Token.invalidToken }
            .eraseToAnyPublisher()
    }
    
}
