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
    
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    public func save(_ token: String) {
        let expirationDate = Date().addingTimeInterval(86000)
        
        keychainService.save(value: token, forKey: .accessToken)
        keychainService.save(value: expirationDate.timeIntervalSince1970, forKey: .accessTokenExpiration)
    }
    
    
    public func get() -> String? {
        guard let expirationDateInterval: Double = keychainService.get(forKey: .accessTokenExpiration) else {
            return nil
        }
        let expirationDate = Date(timeIntervalSince1970: expirationDateInterval)
        
        if expirationDate > Date() {
            return keychainService.get(forKey: .accessToken)
        } else {
            clearAccessToken()
            return nil
        }
    }
    
    
    private func clearAccessToken() {
        keychainService.delete(forKey: .accessToken)
        keychainService.delete(forKey: .accessTokenExpiration)
    }
    
}
