//
//  NewsFeedRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

final class NewsFeedRepositoryImpl: NewsFeedRepository {
    
    private let apiService: APIService
    private let accessTokenStorage: AccessTokenStorage
    
    init(apiService: APIService,
         accessTokenStorage: AccessTokenStorage) {
        self.apiService = apiService
        self.accessTokenStorage = accessTokenStorage
    }
    
    public func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, any Error> {
        guard let accessToken = accessTokenStorage.get() else {
            return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher()
        }
        
        var parameters = VKAPI.Paths.newsFeedGet.parameters(withAccessToken: accessToken)
        
        if let startFrom {
            parameters["start_from"] = startFrom
        }
        
        let request = API.Request(
            scheme: VKAPI.scheme,
            host: VKAPI.host,
            path: VKAPI.Paths.newsFeedGet.rawValue,
            method: .POST,
            parameters: parameters)
        
        return apiService.fetchData(request: request)
    }
    
}
