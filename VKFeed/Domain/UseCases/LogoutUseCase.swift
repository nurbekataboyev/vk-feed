//
//  LogoutUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 03/10/24.
//

import Foundation
import Combine

protocol LogoutUseCase {
    func logout() -> AnyPublisher<Void, Error>
}

final class LogoutUseCaseImpl: LogoutUseCase {
    
    private let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    
    public func logout() -> AnyPublisher<Void, Error> {
        return authenticationRepository.invalidateAccessToken()
            .flatMap { [weak self] response -> AnyPublisher<Void, Error> in
                guard let self else { return Fail(error: VKError.Network.invalidResponse).eraseToAnyPublisher() }
                
                if response.isInvalidated {
                    authenticationRepository.clearAccessToken()
                    
                    return Just(()).setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher()
                }
                
            }
            .eraseToAnyPublisher()
    }
    
}
