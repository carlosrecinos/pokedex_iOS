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
    
    func inject(networking: HttpNetworking) {
        self.networking = networking
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
                        self.saveTokenToKeychain(loginToken)
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
    
    
    func saveTokenToKeychain(_ token: String) {
        print("Token to save: \(token)")
    }
}
