//
//  LoginRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    private let apiService: APIService
    private let tokenManager: TokenManager
    
    init(apiService: APIService,
         tokenManager: TokenManager) {
        self.apiService = apiService
        self.tokenManager = tokenManager
    }
    
    public func exchangeCodeForToken(_ code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<TokenResponse, Error> {
        let request = API.Request(
            scheme: VKIDAPI.scheme,
            host: VKIDAPI.host,
            path: VKIDAPI.Paths.oauth2AuthAuthenticationCode().path,
            method: .POST,
            parameters: VKIDAPI.Paths.oauth2AuthAuthenticationCode(deviceID: deviceID, codeVerifier: codeVerifier).parameters(),
            headers: VKIDAPI.Paths.oauth2AuthAuthenticationCode().headers(),
            body: VKIDAPI.Paths.oauth2AuthAuthenticationCode(code: code).body())
        
        return apiService.fetchData(request: request)
    }
    
    
    public func invalidateTokens() -> AnyPublisher<TokenInvalidationResponse, Error> {
        return tokenManager.getValidAccessToken()
            .flatMap { [weak self] accessToken -> AnyPublisher<TokenInvalidationResponse, Error> in
                guard let self else { return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher() }
                
                let request = API.Request(
                    scheme: VKIDAPI.scheme,
                    host: VKIDAPI.host,
                    path: VKIDAPI.Paths.oauth2Logout().path,
                    method: .POST,
                    parameters: VKIDAPI.Paths.oauth2Logout().parameters(),
                    headers: VKIDAPI.Paths.oauth2Logout(accessToken: accessToken).headers())
                
                return apiService.fetchData(request: request)
            }
            .eraseToAnyPublisher()
    }
    
}
