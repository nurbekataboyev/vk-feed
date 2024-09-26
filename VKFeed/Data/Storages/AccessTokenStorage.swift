//
//  AccessTokenStorage.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

protocol AccessTokenStorage {
    func save(_ token: String)
    func get() -> String?
}

final class AccessTokenStorageImpl: AccessTokenStorage {
    
    private let keychainManager: KeychainManager
    
    init(keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
    }
    
    public func save(_ token: String) {
        let expirationDate = Date().addingTimeInterval(86000)
        
        keychainManager.save(value: token, forKey: .accessToken)
        keychainManager.save(value: expirationDate.timeIntervalSince1970, forKey: .accessTokenExpiration)
    }
    
    
    public func get() -> String? {
        guard let expirationDateInterval: Double = keychainManager.get(forKey: .accessTokenExpiration) else {
            return nil
        }
        let expirationDate = Date(timeIntervalSince1970: expirationDateInterval)
        
        if expirationDate > Date() {
            return keychainManager.get(forKey: .accessToken)
        } else {
            clearAccessToken()
            return nil
        }
    }
    
    
    private func clearAccessToken() {
        keychainManager.delete(forKey: .accessToken)
        keychainManager.delete(forKey: .accessTokenExpiration)
    }
    
}
