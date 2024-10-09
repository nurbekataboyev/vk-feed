//
//  Post.swift
//  VKFeed
//
//  Created by Nurbek on 27/09/24.
//

import Foundation

// ----- Post -----
struct Post: Equatable, Hashable {
    let id: Int
    let text: String
    let photo: PostPhoto?
    var likes: PostLikes
    let createdAt: Date
    let author: PostAuthor?
}

extension Post {
    
    public func toNewsFeedItem(groups: [NewsFeedGroup]?) -> NewsFeedItem? {
        guard let author,
              let group = groups?.first(where: { abs($0.id) == author.id }) else {
            return nil
        }
        
        var attachments: [NewsFeedAttachment] = []
        
        if let photo, let photoURL = photo.photoURL {
            let photo = Photo(height: photo.height, width: photo.width, url: photoURL)
            let attachmentPhoto = AttachmentPhoto(photo: photo)
            let newsFeedAttachment = NewsFeedAttachment(photo: attachmentPhoto)
            
            attachments.append(newsFeedAttachment)
        }
        
        let likes = Likes(count: likes.count, userLikes: likes.userLikes ? 1 : 0)
        
        let newsFeedItem = NewsFeedItem(
            sourceID: -group.id,
            postID: id,
            date: Int(createdAt.timeIntervalSince1970),
            text: text,
            attachments: attachments,
            likes: likes)
        
        return newsFeedItem
    }
    
}

struct PostPhoto: Equatable, Hashable {
    let photoURL: String?
    let height: Int
    let width: Int
}

struct PostLikes: Equatable, Hashable {
    var count: Int
    var userLikes: Bool
}

struct PostAuthor: Equatable, Hashable {
    let id: Int
    let name: String
    let photoURL: String
}


// ----- Post Like -----
struct PostLike: Decodable {
    let response: PostLikeResponse
}

struct PostLikeResponse: Decodable {
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case likes
    }
}
