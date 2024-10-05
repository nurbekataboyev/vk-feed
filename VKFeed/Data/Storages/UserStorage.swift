//
//  UserStorage.swift
//  VKFeed
//
//  Created by Nurbek on 05/10/24.
//

import Foundation

protocol UserStorage {
    func saveUser(_ user: User)
    func getUser() -> User?
    func clearUser()
}

final class UserStorageImpl: UserStorage {
    
    private let userDefaultsService: UserDefaultsService
    
    init(userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }
    
    public func saveUser(_ user: User) {
        userDefaultsService.save(value: user, forKey: .user)
    }
    
    
    public func getUser() -> User? {
        return userDefaultsService.get(forKey: .user)
    }
    
    
    public func clearUser() {
        userDefaultsService.delete(forKey: .user)
    }
    
}
