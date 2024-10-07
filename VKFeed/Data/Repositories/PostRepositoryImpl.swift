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
    private let tokenManager: TokenManager
    
    init(apiService: APIService,
         tokenManager: TokenManager) {
        self.apiService = apiService
        self.tokenManager = tokenManager
    }
    
    public func likePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error> {
        return toggleLike(.like, ownerID: ownerID, postID: postID)
    }
    
    
    public func unlikePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error> {
        return toggleLike(.unlike, ownerID: ownerID, postID: postID)
    }
    
}


extension PostRepositoryImpl {
    
    private enum LikeType {
        case like, unlike
    }
    
    private func toggleLike(_ likeType: LikeType, ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error> {
        return tokenManager.getValidAccessToken()
            .flatMap { [weak self] accessToken -> AnyPublisher<PostLike, Error> in
                guard let self else { return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher() }
                
                let shouldLike = likeType == .like
                
                let path = shouldLike ? VKAPI.Paths.likesAdd().path : VKAPI.Paths.likesDelete().path
                let parameters = shouldLike ?
                VKAPI.Paths.likesAdd(ownerID: ownerID, itemID: postID).parameters(withAccessToken: accessToken)
                :
                VKAPI.Paths.likesDelete(ownerID: ownerID, itemID: postID).parameters(withAccessToken: accessToken)
                
                let request = API.Request(
                    scheme: VKAPI.scheme,
                    host: VKAPI.host,
                    path: path,
                    method: .POST,
                    parameters: parameters)
                
                return apiService.fetchData(request: request)
            }
            .eraseToAnyPublisher()
    }
    
}
