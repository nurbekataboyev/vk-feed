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
    let photoURL: String?
    let likes: PostLikes
    let createdAt: Date
    let author: PostAuthor?
}

struct PostLikes {
    var count: Int
    var userLikes: Bool
}

struct PostAuthor {
    let id: Int
    let name: String
    let photoURL: String
}
