import Foundation

enum KeychainError: Error {
    case noToken
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

enum KeychainActions {
    case add
    case search
    case update
    case delete
}

class KeychainManager {
    
    func saveToken(username: String, token: String) -> Bool {
        var isSuccess = false
        do {
            let savedDictionary = try searchToken(username: username)
            
            if savedDictionary == nil {
                print("already saved")
                isSuccess = true
            } else {
                print("to save key")
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
    
    func searchToken(username: String) throws -> [String: Any]? {
        do {
            var item: CFTypeRef?
            let query = try prepareKeychainQuery(username: username, action: .search, token: nil)
            SecItemCopyMatching(query as CFDictionary, &item)
            return item as? [String: Any]
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
    
    func prepareKeychainQuery(username: String, action: KeychainActions, token: String?) throws -> [String: Any] {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: username]
        switch action {
            
        case .add:
            guard let token = token else {
                throw KeychainError.noToken
            }
            query[kSecAttrGeneric as String] = token
        case .search, .delete, .update:
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = false
            query[kSecReturnData as String] = true
        }
        
        return query
    }
    
}
