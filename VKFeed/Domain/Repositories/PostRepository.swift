//
//  PostRepository.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol PostRepository {
    func likePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error>
    func unlikePost(ownerID: Int?, postID: Int) -> AnyPublisher<PostLike, Error>
}
