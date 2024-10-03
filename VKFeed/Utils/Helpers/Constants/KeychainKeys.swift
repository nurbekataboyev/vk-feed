//
//  KeychainKeys.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

struct KeychainKeys {
    
    static let accessGroup = "com.nurbekios.vkfeed"
    
    enum Key: String {
        case accessToken = "accessTokenKey"
        case accessTokenExpiration = "accessTokenExpirationKey"
    }
    
}
