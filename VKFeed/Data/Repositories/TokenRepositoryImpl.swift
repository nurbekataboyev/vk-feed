//
//  TokenRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 06/10/24.
//

import Foundation
import Combine

final class TokenRepositoryImpl: TokenRepository {
    
    private let apiService: APIService
    private let tokenStorage: TokenStorage
    
    init(apiService: APIService,
         tokenStorage: TokenStorage) {
        self.apiService = apiService
        self.tokenStorage = tokenStorage
    }
    
    public func refreshTokens() -> AnyPublisher<TokenResponse, Error> {
        let deviceID = tokenStorage.getDeviceID()
        let refreshToken = tokenStorage.getRefreshToken()
        
        let request = API.Request(
            scheme: VKIDAPI.scheme,
            host: VKIDAPI.host,
            path: VKIDAPI.Paths.oauth2AuthRefreshToken().path,
            method: .POST,
            parameters: VKIDAPI.Paths.oauth2AuthRefreshToken(deviceID: deviceID).parameters(),
            headers: VKIDAPI.Paths.oauth2AuthRefreshToken().headers(),
            body: VKIDAPI.Paths.oauth2AuthRefreshToken(refreshToken: refreshToken).body())
        
        return apiService.fetchData(request: request)
    }
    
    
    public func isAccessTokenValid() -> Bool {
        return tokenStorage.isAccessTokenValid()
    }
    
    
    public func getAccessToken() -> String? {
        return tokenStorage.getAccessToken()
    }
    
    
    public func saveTokens(accessToken: String, refreshToken: String, deviceID: String, expiresIn: Int) {
        tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken, deviceID: deviceID, expiresIn: expiresIn)
    }
    
    
    public func updateTokens(accessToken: String, refreshToken: String, expiresIn: Int) {
        tokenStorage.updateTokens(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
    }
    
    
    public func clearTokens() {
        tokenStorage.clearTokens()
    }
    
}
