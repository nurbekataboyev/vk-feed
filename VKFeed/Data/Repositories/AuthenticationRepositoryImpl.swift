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
    private let accessTokenStorage: AccessTokenStorage
    
    init(apiService: APIService,
         accessTokenStorage: AccessTokenStorage) {
        self.apiService = apiService
        self.accessTokenStorage = accessTokenStorage
    }
    
    public func exchangeCodeForToken(_ code: String, deviceID: String, codeVerifier: String) -> AnyPublisher<AuthenticationResponse, Error> {
        let request = API.Request(
            scheme: VKIDAPI.scheme,
            host: VKIDAPI.host,
            path: VKIDAPI.Paths.oauth2Auth().rawValue,
            method: .POST,
            parameters: VKIDAPI.Paths.oauth2Auth(deviceID: deviceID, codeVerifier: codeVerifier).parameters(),
            headers: VKIDAPI.Paths.oauth2Auth().headers(),
            body: VKIDAPI.Paths.oauth2Auth(code: code).body())
        
        return apiService.fetchData(request: request)
    }
    
    
    public func invalidateAccessToken() -> AnyPublisher<TokenInvalidationResponse, Error> {
        let accessToken = accessTokenStorage.getAccessToken()
        
        let request = API.Request(
            scheme: VKIDAPI.scheme,
            host: VKIDAPI.host,
            path: VKIDAPI.Paths.oauth2Logout().rawValue,
            method: .POST,
            parameters: VKIDAPI.Paths.oauth2Logout().parameters(),
            headers: VKIDAPI.Paths.oauth2Logout(accessToken: accessToken).headers())
        
        return apiService.fetchData(request: request)
    }
    
    
    public func saveAccessToken(_ token: String) {
        accessTokenStorage.saveAccessToken(token)
    }
    
    
    public func clearAccessToken() {
        accessTokenStorage.clearAccessToken()
    }
    
}
