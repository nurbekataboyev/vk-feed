//
//  LoginRepository.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol AuthenticationRepository {
    func exchangeCodeForToken(_ code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<TokenResponse, Error>
    func invalidateTokens() -> AnyPublisher<TokenInvalidationResponse, Error>
}
