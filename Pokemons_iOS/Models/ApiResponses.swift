//
//  Requests.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/12/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation


struct PokemonsResponse: Decodable {
    let error: Bool
    let data: PokeapiPayload?
}

struct PokeapiPayload: Decodable {
    let count: Int?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

struct LoginResponse: Decodable {
    let error: Bool
    let data: LoginPayload
}

struct LoginPayload: Decodable {
    let user: User
    let loginToken: String
}
