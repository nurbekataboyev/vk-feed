//
//  AccessTokenStorage.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

protocol AccessTokenStorage {
    func saveAccessToken(_ token: String, expiresIn seconds: Int)
    func getAccessToken() -> String?
    func clearAccessToken()
}

final class AccessTokenStorageImpl: AccessTokenStorage {
    
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    public func saveAccessToken(_ token: String, expiresIn seconds: Int) {
        let expirationDateInterval = Double(seconds - 100) // extra 100 for safety
        let expirationDate = Date().addingTimeInterval(expirationDateInterval)
        
        keychainService.save(value: token, forKey: .accessToken)
        keychainService.save(value: expirationDate.timeIntervalSince1970, forKey: .accessTokenExpiration)
    }
    
    
    public func getAccessToken() -> String? {
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
    
    
    public func clearAccessToken() {
        keychainService.delete(forKey: .accessToken)
        keychainService.delete(forKey: .accessTokenExpiration)
    }
    
}
