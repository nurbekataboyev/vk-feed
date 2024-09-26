//
//  KeychainManager.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import Foundation

final class KeychainManager {
    
    public func save<Value: Encodable>(value: Value, forKey key: KeychainKeys.Key) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    
    public func get<Value: Decodable>(forKey key: KeychainKeys.Key) -> Value? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(Value.self, from: data)
    }
    
    
    public func delete(forKey key: KeychainKeys.Key) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
}
