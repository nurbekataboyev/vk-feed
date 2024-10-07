//
//  Authentication.swift
//  VKFeed
//
//  Created by Nurbek on 03/10/24.
//

import Foundation

// ----- Authentication -----
struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}


// ----- Token Invalidation -----
struct TokenInvalidationResponse: Decodable {
    let response: Int
    
    var isInvalidated: Bool { response == 1 }
}
