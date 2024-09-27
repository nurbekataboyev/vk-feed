//
//  Post.swift
//  VKFeed
//
//  Created by Nurbek on 27/09/24.
//

import Foundation

struct Post {
    let postID: Int
    let text: String
    let photosURLs: [String?]
    let likesCount: Int
    let userLikes: Bool
    let createdAt: Date
    let owner: PostOwner?
}

struct PostOwner {
    let id: Int
    let name: String
    let photoURL: String
}
