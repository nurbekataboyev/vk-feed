//
//  UserDefaultsService.swift
//  VKFeed
//
//  Created by Nurbek on 05/10/24.
//

import Foundation

protocol UserDefaultsService {
    func save<Value: Encodable>(value: Value, forKey key: UserDefaultsKeys.Key)
    func get<Value: Decodable>(forKey key: UserDefaultsKeys.Key) -> Value?
    func delete(forKey key: UserDefaultsKeys.Key)
}

final class UserDefaultsServiceImpl: UserDefaultsService {
    
    private let userDefaults = UserDefaults.standard
    
    public func save<Value: Encodable>(value: Value, forKey key: UserDefaultsKeys.Key) {
        if let encodedValue = try? JSONEncoder().encode(value) {
            userDefaults.set(encodedValue, forKey: key.rawValue)
        }
    }
    
    
    public func get<Value: Decodable>(forKey key: UserDefaultsKeys.Key) -> Value? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        
        return try? JSONDecoder().decode(Value.self, from: data)
    }
    
    
    public func delete(forKey key: UserDefaultsKeys.Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
}
