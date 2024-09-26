//
//  LoginRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    
    private let storage: AccessTokenStorage
    
    init(storage: AccessTokenStorage) {
        self.storage = storage
    }
    
    public func saveAccessToken(_ token: String) {
        storage.save(token)
    }
    
    
    public func getAccessToken() -> String? {
        return storage.get()
    }
    
}
