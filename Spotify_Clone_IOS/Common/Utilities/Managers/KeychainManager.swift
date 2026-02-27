//
//  KeychainManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 25.02.2026.
//

import Foundation
import Security

final class KeychainManager{
    static let shared = KeychainManager()
    
    private init() {}
    
    enum KeychainError: Error {
        case duplicateEntry
        case noPassword
        case unknown(OSStatus)
    }
    
    // MARK: - Save
    @discardableResult
    func save(key: KeychainKey, data: Data) -> OSStatus {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
                kSecValueData as String: data
            ] as [String: Any]
            
            SecItemDelete(query as CFDictionary)
            return SecItemAdd(query as CFDictionary, nil)
        }
    
    // MARK: - Read
    func read(key: KeychainKey) -> Data? {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.rawValue,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ] as [String: Any]
            
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            return (status == errSecSuccess) ? (dataTypeRef as? Data) : nil
        }
    
    // MARK: - Delete
    @discardableResult
    func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as [String: Any]
        
        return SecItemDelete(query as CFDictionary)
    }
}

