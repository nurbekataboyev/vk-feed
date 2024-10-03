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
        var headers: [String: String]? = nil
        var body: Data? = nil
    }
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    struct HeaderField {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
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
        
        if let headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        if let body { request.httpBody = body }
        
        return request
    }
    
}


struct VKIDAPI {
    static let scheme = "https"
    static let host = "id.vk.com"
    
    enum Paths {
        case authorize(codeChallenge: String? = nil)
        case oauth2Auth(code: String? = nil, deviceID: String? = nil, codeVerifier: String? = nil)
        case oauth2Logout(accessToken: String? = nil)
        
        var rawValue: String {
            switch self {
            case .authorize:
                return "/authorize"
            case .oauth2Auth:
                return "/oauth2/auth"
            case .oauth2Logout:
                return "/oauth2/logout"
            }
        }
    }
}

extension VKIDAPI.Paths {
    
    public func headers() -> [String: String] {
        var headers: [String: String] = [:]
        
        switch self {
        case .authorize:
            return headers
            
        case .oauth2Auth:
            headers[API.HeaderField.contentType] = API.HeaderValue.applicationJSON
            
            return headers
            
        case .oauth2Logout(let accessToken):
            if let accessToken {
                headers[API.HeaderField.authorization] = "\(API.HeaderValue.bearerToken) \(accessToken)"
            }
            
            return headers
        }
    }
    
    
    public func body() -> Data? {
        var body: [String: Any] = [:]
        
        switch self {
        case .authorize:
            return nil
            
        case .oauth2Auth(let code, _, _):
            body["code"] = code
            
        case .oauth2Logout:
            return nil
        }
        
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return data
    }
    
    
    public func parameters() -> [String: String] {
        var params: [String: String] = [
            "client_id": VKConfig.clientID
        ]
        
        switch self {
        case .authorize(let codeChallenge):
            params["state"] = "abracadabra"
            params["response_type"] = "code"
            params["code_challenge_method"] = "s256"
            params["redirect_uri"] = VKConfig.redirectURI
            params["prompt"] = "login"
            params["scope"] = "offline%wall%friends"
            
            if let codeChallenge { params["code_challenge"] = codeChallenge }
            
            return params
            
        case .oauth2Auth(_, let deviceID, let codeVerifier):
            params["state"] = "abracadabracodeexchange"
            params["grant_type"] = "authorization_code"
            params["redirect_uri"] = VKConfig.redirectURI
            
            if let deviceID, let codeVerifier {
                params["device_id"] = deviceID
                params["code_verifier"] = codeVerifier
            }
            
            return params
            
        case .oauth2Logout:
            return params
        }
    }
    
}


struct VKAPI {
    static let scheme = "https"
    static let host = "api.vk.com"
    
    enum Paths {
        case usersGet
        case newsFeedGet(startFrom: String? = nil)
        case likesAdd
        case likesDelete
        
        var rawValue: String {
            switch self {
            case .usersGet:
                return "/method/users.get"
            case .newsFeedGet:
                return "/method/newsfeed.get"
            case .likesAdd:
                return "/method/likes.add"
            case .likesDelete:
                return "/method/likes.delete"
            }
        }
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
            
        case .newsFeedGet(let startFrom):
            params["filters"] = "post"
            params["count"] = "50"
            
            if let startFrom { params["start_from"] = startFrom }
            
            return params
            
        case .likesAdd, .likesDelete:
            return params
        }
    }
    
}
