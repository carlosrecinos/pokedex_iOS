//
//  Requests.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/12/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation


struct PokemonsResponse: Decodable {
    var error: Bool?
    var data: PokeapiPayload?
}

struct PokeapiPayload: Decodable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}
