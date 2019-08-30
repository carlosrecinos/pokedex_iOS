//
//  PokemonService.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures

enum AuthenticationServiceError: Error {
    case notFound
    case serviceError
    case invalidCredentials
    case decodingError
}

protocol AuthenticationServiceProtocol {
    func signIn(_ username: String, _ password: String) -> Future<User, AuthenticationServiceError>
}

class AuthenticationService: AuthenticationServiceProtocol {
    var networking: HttpNetworking?
    var keychainManager: KeychainManager?
    
    func inject(networking: HttpNetworking, keychainManager: KeychainManager) {
        self.networking = networking
        self.keychainManager = keychainManager
    }
    
    func signIn(_ username: String, _ password: String) -> Future<User, AuthenticationServiceError> {
        let promise = Promise<User, AuthenticationServiceError>()
        networking?.post(url: "https://recinospokedex.herokuapp.com/api/authentication/login", httpHeaders: nil, parameters: ["username": username, "password": password])
            .onSuccess(callback: { response in
                if let responseData = response.data {
                    do {
                        let decodedData = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                        let loggedUser = decodedData.data.user
                        let loginToken = decodedData.data.loginToken
                        
                        let isSuccess = self.saveTokenToKeychain(username: username, token: loginToken)
                        if !isSuccess {
                            print("Error saving token")
                        }
                        
                        promise.success(loggedUser)
                    } catch {
                        promise.failure(.decodingError)
                    }
                }
            })
        .onFailure(callback: { error in
            promise.failure(.serviceError)
        })
        return promise.future
    }
    
    
    func saveTokenToKeychain(username: String, token: String) -> Bool {
        let isSuccess = keychainManager?.saveToken(username: username, token: token)
        return isSuccess!
    }
}
