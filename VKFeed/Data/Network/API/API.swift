//
//  API.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct VKAuthAPI {
    static let scheme = "https"
    static let host = "oauth.vk.com"
    static let path = "/authorize"
    
    static let redirectPath = "/blank.html"
    
    struct Parameters {
        static let clientID = ["client_id", VKConfig.clientID]
        static let redirectURI = ["redirect_uri", "https://oauth.vk.com/blank.html"]
        static let display = ["display", "mobile"]
        static let scope = ["scope", "friends,wall"]
        static let response_type = ["response_type", "token"]
    }
}

extension VKAuthAPI.Parameters {
    
    static func toQueryItems() -> [URLQueryItem] {
        let parameters = [clientID, redirectURI, display, scope, response_type]
        let items = parameters.map { URLQueryItem(name: $0[0], value: $0[1]) }
        
        return items
    }
    
}


struct VKAPI {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    
    struct Methods {
        static let user = "/method/users.get"
        static let newsFeed = "/method/newsfeed.get"
    }
}
