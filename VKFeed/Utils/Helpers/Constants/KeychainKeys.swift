//
//  KeychainKeys.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

struct KeychainKeys {
    
    enum Key: String {
        case accessToken = "accessTokenKey"
        case refreshToken = "refreshTokenKey"
        case deviceID = "deviceIDKey"
        case accessTokenExpiration = "accessTokenExpirationKey"
    }
    
}
