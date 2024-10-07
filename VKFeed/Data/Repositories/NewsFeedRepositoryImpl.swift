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
    private let tokenManager: TokenManager
    
    init(apiService: APIService,
         tokenManager: TokenManager) {
        self.apiService = apiService
        self.tokenManager = tokenManager
    }
    
    public func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error> {
        return tokenManager.getValidAccessToken()
            .flatMap { [weak self] accessToken -> AnyPublisher<NewsFeed, Error> in
                guard let self else { return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher() }
                
                let request = API.Request(
                    scheme: VKAPI.scheme,
                    host: VKAPI.host,
                    path: VKAPI.Paths.newsFeedGet().path,
                    method: .POST,
                    parameters: VKAPI.Paths.newsFeedGet(startFrom: startFrom).parameters(withAccessToken: accessToken))
                
                return apiService.fetchData(request: request)
            }
            .eraseToAnyPublisher()
    }
    
}
