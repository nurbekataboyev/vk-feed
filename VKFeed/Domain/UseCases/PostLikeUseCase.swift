//
//  PostLikeUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol PostLikeUseCase {
    func toggleLike(for post: Post) -> AnyPublisher<Post, Error>
}

final class PostLikeUseCaseImpl: PostLikeUseCase {
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    public func toggleLike(for post: Post) -> AnyPublisher<Post, Error> {
        let isLiked = post.likes.userLikes
        
        return isLiked ? unlike(post: post) : like(post: post)
    }
    
}


extension PostLikeUseCaseImpl {
    
    private func like(post: Post) -> AnyPublisher<Post, Error> {
        return postRepository.likePost(ownerID: post.author?.id, postID: post.id)
            .map { _ in
                var updatedPost = post
                
                updatedPost.likes.userLikes = true
                updatedPost.likes.count += 1
                
                return updatedPost
            }
            .eraseToAnyPublisher()
    }
    
    
    private func unlike(post: Post) -> AnyPublisher<Post, Error> {
        return postRepository.unlikePost(ownerID: post.author?.id, postID: post.id)
            .map { _ in
                var updatedPost = post
                
                updatedPost.likes.userLikes = false
                updatedPost.likes.count -= 1
                
                return updatedPost
            }
            .eraseToAnyPublisher()
    }
    
}
