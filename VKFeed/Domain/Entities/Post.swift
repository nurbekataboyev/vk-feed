//
//  Post.swift
//  VKFeed
//
//  Created by Nurbek on 27/09/24.
//

import Foundation

struct Post {
    let postID: String
    let text: String
    let owner: PostOwner
}

struct PostOwner {
    let id: String
    let name: String
    let photoURL: String
}
