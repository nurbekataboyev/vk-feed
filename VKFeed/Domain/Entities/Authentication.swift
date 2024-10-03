//
//  Authentication.swift
//  VKFeed
//
//  Created by Nurbek on 03/10/24.
//

import Foundation

struct AuthenticationResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    let idToken: String
    let refreshToken: String
    let scope: String
    let state: String
    let tokenType: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case scope
        case state
        case tokenType = "token_type"
        case userId = "user_id"
    }
}

struct TokenInvalidationResponse: Decodable {
    let response: Int
    
    var isInvalidated: Bool { response == 1 }
}
