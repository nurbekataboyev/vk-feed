//
//  NewsFeed.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct NewsFeed: Decodable {
    var response: NewsFeedResponse?
}

struct NewsFeedResponse: Decodable {
    var items: [NewsFeedItem]
    var groups: [NewsFeedGroup]
    var nextFrom: String?
    
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

extension NewsFeedItem {
    
    public func toPost(groups: [NewsFeedGroup]) -> Post {
        let likes = PostLikes(count: likes.count, userLikes: likes.userLikes == 1)
        var author: PostAuthor? = nil
        
        if let postAuthor = groups.first(where: { $0.id == abs(sourceID) }) {
            author = PostAuthor(id: postAuthor.id, name: postAuthor.name, photoURL: postAuthor.photoURL)
        }
        
        let post = Post(
            postID: postID,
            text: text,
            photoURL: attachments.first?.photo?.photo.url,
            likes: likes,
            createdAt: Date(timeIntervalSince1970: TimeInterval(date)),
            author: author)
        
        return post
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
