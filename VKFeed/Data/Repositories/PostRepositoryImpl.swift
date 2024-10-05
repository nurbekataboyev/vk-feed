//
//  PostRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

final class PostRepositoryImpl: PostRepository {
    
    private let apiService: APIService
    private let accessTokenStorage: AccessTokenStorage
    
    init(apiService: APIService,
         accessTokenStorage: AccessTokenStorage) {
        self.apiService = apiService
        self.accessTokenStorage = accessTokenStorage
    }
    
    public func likePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error> {
        guard let accessToken = accessTokenStorage.getAccessToken() else {
            return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher()
        }
        
        let request = API.Request(
            scheme: VKAPI.scheme,
            host: VKAPI.host,
            path: VKAPI.Paths.likesAdd().path,
            method: .POST,
            parameters: VKAPI.Paths.likesAdd(ownerID: ownerID, itemID: postID).parameters(withAccessToken: accessToken))
        
        return apiService.fetchData(request: request)
    }
    
    
    public func unlikePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error> {
        guard let accessToken = accessTokenStorage.getAccessToken() else {
            return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher()
        }
        
        let request = API.Request(
            scheme: VKAPI.scheme,
            host: VKAPI.host,
            path: VKAPI.Paths.likesDelete().path,
            method: .POST,
            parameters: VKAPI.Paths.likesDelete(ownerID: ownerID, itemID: postID).parameters(withAccessToken: accessToken))
        
        return apiService.fetchData(request: request)
    }
    
}
