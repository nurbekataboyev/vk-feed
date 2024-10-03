//
//  AuthenticationHelper.swift
//  VKFeed
//
//  Created by Nurbek on 03/10/24.
//

import Foundation
import CommonCrypto

struct AuthenticationHelper {
    
    static func generateCodeVerifier() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        let codeVerifier = String((0..<128).compactMap { _ in characters.randomElement() })
        return codeVerifier
    }
    
    
    static func generateCodeChallenge(from verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else { return "" }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        
        let hashedData = Data(hash)
        
        let base64String = hashedData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        return base64String
    }
    
}
