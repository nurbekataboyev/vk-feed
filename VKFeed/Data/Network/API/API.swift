//
//  API.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct API {
    
    struct Request {
        let scheme: String
        let host: String
        let path: String
        let method: HTTPMethod
        let parameters: [String: String]?
    }
    
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
}

extension API.Request {
    
    public func createURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        if let parameters {
            urlComponents.queryItems = toQueryItems(parameters)
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    
    private func toQueryItems(_ parameters: [String: String]) -> [URLQueryItem] {
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return queryItems
    }
    
}


struct VKAuthAPI {
    static let scheme = "https"
    static let host = "oauth.vk.com"
    
    enum Paths: String {
        case authorize = "/authorize"
        case redirect = "/blank.html"
    }
}

extension VKAuthAPI.Paths {
    
    public func parameters() -> [String: String]? {
        switch self {
        case .authorize:
            let params = [
                "client_id": VKConfig.clientID,
                "redirect_uri": "https://oauth.vk.com/blank.html",
                "display": "mobile",
                "scope": "friends,wall",
                "response_type": "token"
            ]
            
            return params
            
        case .redirect:
            return nil
        }
    }
    
}


struct VKAPI {
    static let scheme = "https"
    static let host = "api.vk.com"
    
    enum Paths: String {
        case usersGet = "/method/users.get"
        case newsFeedGet = "/method/newsfeed.get"
        case likesAdd = "/method/likes.add"
        case likesDelete = "/method/likes.delete"
    }
}

extension VKAPI.Paths {
    
    public func parameters(withAccessToken accessToken: String) -> [String: String] {
        switch self {
        case .usersGet:
            let params = [
                "access_token": accessToken,
                "v": "5.131"
            ]
            
            return params
            
        case .newsFeedGet:
            let params = [
                "access_token": accessToken,
                "filters": "post",
                "count": "50",
                "v": "5.131"
            ]
            
            return params
            
        case .likesAdd:
            let params = [
                "access_token": accessToken,
                "v": "5.131"
            ]
            
            return params
            
        case .likesDelete:
            let params = [
                "access_token": accessToken,
                "v": "5.131"
            ]
            
            return params
        }
    }
    
}
