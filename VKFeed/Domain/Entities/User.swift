//
//  User.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct User: Codable {
    let response: [UserResponse]
}

struct UserResponse: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
