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
        var parameters: [String: String]? = nil
        var headers: [HeaderField: String]? = nil
        var body: Data? = nil
    }
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum HeaderField: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }
    
    struct HeaderValue {
        static let applicationJSON = "application/json"
        static let bearerToken = "Bearer"
    }
    
}

extension API.Request {
    
    public func createURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        if let parameters { urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) } }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(API.HeaderValue.applicationJSON, forHTTPHeaderField: API.HeaderField.contentType.rawValue)
        
        if let headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field.rawValue)
            }
        }
        
        if let body { request.httpBody = body }
        
        return request
    }
    
    
    static func createBody(key: String, value: Any?) -> Data? {
        let jsonBody = [key: value]
        let data = try? JSONSerialization.data(withJSONObject: jsonBody, options: [])
        
        return data
    }
    
}


struct VKIDAPI {
    static let scheme = "https"
    static let host = "id.vk.com"
    
    enum Paths {
        case authorize(codeChallenge: String? = nil)
        case oauth2Auth(deviceID: String? = nil, codeVerifier: String? = nil)
        
        var rawValue: String {
            switch self {
            case .authorize:
                return "/authorize"
            case .oauth2Auth:
                return "/oauth2/auth"
            }
        }
    }
    
    struct Headers {
        static let contentTypeJSON = [API.HeaderField.contentType: API.HeaderValue.applicationJSON]
    }
}

extension VKIDAPI.Paths {
    
    public func parameters() -> [String: String] {
        switch self {
        case .authorize(let codeChallenge):
            var params = [
                "state": "abracadabra",
                "response_type": "code",
                
                "code_challenge_method": "s256",
                "client_id": VKConfig.clientID,
                "redirect_uri": VKConfig.redirectURI,
                "prompt": "login",
                "scope": "offline%wall%friends"
            ]
            
            if let codeChallenge { params["code_challenge"] = codeChallenge }
            
            return params
            
        case .oauth2Auth(let deviceID, let codeVerifier):
            var params = [
                "state": "abracadabracodeexchange",
                "grant_type": "authorization_code",
                "redirect_uri": VKConfig.redirectURI,
                "client_id": VKConfig.clientID
            ]
            
            if let deviceID, let codeVerifier {
                params["device_id"] = deviceID
                params["code_verifier"] = codeVerifier
            }
            
            return params
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
        var params: [String: String] = [
            "access_token": accessToken,
            "v": "5.131"
        ]
        
        switch self {
        case .usersGet:
            return params
            
        case .newsFeedGet:
            params["filters"] = "post"
            params["count"] = "50"
            
            return params
            
        case .likesAdd, .likesDelete:
            return params
        }
    }
    
}
