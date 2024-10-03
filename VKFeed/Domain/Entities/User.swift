//
//  User.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct User: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
