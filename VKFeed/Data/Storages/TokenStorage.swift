//
//  TokenStorage.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

protocol TokenStorage {
    func saveTokens(accessToken: String, refreshToken: String, deviceID: String, expiresIn seconds: Int)
    func updateTokens(accessToken: String, refreshToken: String, expiresIn seconds: Int)
    
    func isAccessTokenValid() -> Bool
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func getDeviceID() -> String?
    func clearTokens()
}

final class TokenStorageImpl: TokenStorage {
    
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    public func saveTokens(accessToken: String, refreshToken: String, deviceID: String, expiresIn seconds: Int) {
        saveAllTokens(accessToken: accessToken, refreshToken: refreshToken, deviceID: deviceID, expiresIn: seconds)
    }
    
    
    public func updateTokens(accessToken: String, refreshToken: String, expiresIn seconds: Int) {
        saveAllTokens(accessToken: accessToken, refreshToken: refreshToken, expiresIn: seconds)
    }
    
    
    public func isAccessTokenValid() -> Bool {
        guard let expirationDateInterval: Double = keychainService.get(forKey: .accessTokenExpiration) else {
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: expirationDateInterval)
        let isAccessTokenValid = expirationDate > Date()
        
        return isAccessTokenValid
    }
    
    
    public func getAccessToken() -> String? {
        let isAccessTokenValid = isAccessTokenValid()
        
        return isAccessTokenValid ? keychainService.get(forKey: .accessToken) : nil
    }
    
    
    public func getRefreshToken() -> String? {
        return keychainService.get(forKey: .refreshToken)
    }
    
    
    public func getDeviceID() -> String? {
        return keychainService.get(forKey: .deviceID)
    }
    
    
    public func clearTokens() {
        keychainService.delete(forKey: .accessToken)
        keychainService.delete(forKey: .refreshToken)
        keychainService.delete(forKey: .deviceID)
        keychainService.delete(forKey: .accessTokenExpiration)
    }
    
}


extension TokenStorageImpl {
    
    private func saveAllTokens(accessToken: String, refreshToken: String, deviceID: String? = nil, expiresIn seconds: Int) {
        let expirationDateInterval = Double(seconds - 100) // extra 100 for safety
        let expirationDate = Date().addingTimeInterval(expirationDateInterval)
        
        keychainService.save(value: accessToken, forKey: .accessToken)
        keychainService.save(value: refreshToken, forKey: .refreshToken)
        keychainService.save(value: expirationDate.timeIntervalSince1970, forKey: .accessTokenExpiration)
        
        if let deviceID { keychainService.save(value: deviceID, forKey: .deviceID) }
    }
    
}
