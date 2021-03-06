import Foundation

enum KeychainError: Error {
    case noToken
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

enum KeychainActions {
    case add
    case checkIfExists
    case search
    case update
    case delete
}

class KeychainManager {
    
    func saveToken(username: String, token: String) -> Bool {
        var isSuccess = false
        do {
            let tokenExists = try searchToken(username: username)
            if tokenExists {
                isSuccess = true
            } else {
                try saveKeychain(username: username, token: token)
                isSuccess = true
            }
        } catch let error as KeychainError {
            print(error)
        } catch let unhandledError {
            print(unhandledError)
        }
        return isSuccess
    }
    
    func isLogged() -> Bool {
        var isLogged = false
        do {
            let query = try prepareKeychainQuery(username: nil, action: .checkIfExists, token: nil)
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            if status == errSecSuccess {
                isLogged = true
            }
            
        } catch let error {
            print(error)
        }
        return isLogged
    }
    
    /// Returns false if the token does not exist
    func searchToken(username: String) throws -> Bool {
        do {
            var item: CFTypeRef?
            let query = try prepareKeychainQuery(username: username, action: .search, token: nil)
            SecItemCopyMatching(query as CFDictionary, &item)
            let castedItem = item as? [String: Any]
            
            if castedItem != nil {
                return true
            }
            
            return false
        } catch let error as KeychainError {
            throw error
        }
    }
    
    func deleteToken(username: String) throws {
        do {
            let query = try prepareKeychainQuery(username: username, action: .delete, token: nil)
            let status = SecItemDelete(query as CFDictionary)
            
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch let error as KeychainError {
            print(error)
        }
    }
    
    func saveKeychain(username: String, token: String) throws {
        do {
            
            let query = try prepareKeychainQuery(username: username, action: .add, token: token)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                throw KeychainError.unhandledError(status: status)
            }
            
        } catch let error as KeychainError {
            throw error
        }
    }
    
    func prepareKeychainQuery(username: String?, action: KeychainActions, token: String?) throws -> [String: Any] {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: "loggedUser"]
        
        switch action {
        case .delete:
            query[kSecAttrAccount as String] = nil
            break
        case .add:
            guard let token = token else {
                throw KeychainError.noToken
            }
            query[kSecAttrGeneric as String] = token
            query[kSecAttrAccount as String] = username
            break
        case .checkIfExists:
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            break
        case .search, .update:
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            query[kSecAttrAccount as String] = username
            break
        }
        
        return query
    }
    
}
