//
//  NewsFeed.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct NewsFeed: Decodable {
    let response: NewsFeedResponse?
}

extension NewsFeedItem {
    
    public func toPost(groups: [NewsFeedGroup]) -> Post {
        var owner: PostOwner? = nil
        
        if let postOwner = groups.first(where: { $0.id == abs(sourceID) }) {
            owner = PostOwner(id: postOwner.id, name: postOwner.name, photoURL: postOwner.photoURL)
        }
        
        let post = Post(
            postID: postID,
            text: text,
            photosURLs: attachments.map { $0.photo?.photo.url },
            likesCount: likes.count,
            userLikes: likes.userLikes == 1,
            createdAt: Date(timeIntervalSince1970: TimeInterval(date)),
            owner: owner)
        
        return post
    }
    
}

struct NewsFeedResponse: Decodable {
    let items: [NewsFeedItem]
    let groups: [NewsFeedGroup]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items, groups
        case nextFrom = "next_from"
    }
}

struct NewsFeedItem: Decodable {
    let sourceID: Int
    let postID: Int
    let date: Int
    let text: String
    let attachments: [NewsFeedAttachment]
    let likes: Likes
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case postID = "post_id"
        case date, text, attachments, likes
    }
}

struct NewsFeedAttachment: Decodable {
    let photo: AttachmentPhoto?
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
}

struct AttachmentPhoto: Decodable {
    let photo: Photo
    
    enum CodingKeys: String, CodingKey {
        case photo = "orig_photo"
    }
}

struct Photo: Decodable {
    let height: Int
    let width: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case height, width, url
    }
}

struct Likes: Decodable {
    let count: Int
    let userLikes: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct NewsFeedGroup: Decodable {
    let id: Int
    let name: String
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photoURL = "photo_200"
    }
}
