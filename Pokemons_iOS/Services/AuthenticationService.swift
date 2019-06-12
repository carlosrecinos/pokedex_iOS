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
        print("From service")
        let promise = Promise<User, AuthenticationServiceError>()
        if(username == "carlosrecinos" && password == "chalate") {
            let loggedUser = User(id: 1, name: "Carlos Recinos", username: username)
            promise.success(loggedUser)
        } else {
            promise.failure(.invalidCredentials)
        }
        return promise.future.delay(.seconds(4))
    }
}
