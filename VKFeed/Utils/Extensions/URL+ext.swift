//
//  URL+ext.swift
//  VKFeed
//
//  Created by Nurbek on 03/10/24.
//

import Foundation

extension URL {
    
    public var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return [:] }
        
        return Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
    }
    
}
