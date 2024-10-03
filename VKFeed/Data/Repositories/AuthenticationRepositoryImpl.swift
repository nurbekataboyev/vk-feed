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
            headers: VKIDAPI.Headers.contentTypeJSON,
            body: API.Request.createBody(key: "code", value: code))
        
        return apiService.fetchData(request: request)
    }
    
    
    public func saveAccessToken(_ token: String) {
        accessTokenStorage.save(token)
    }
    
}
