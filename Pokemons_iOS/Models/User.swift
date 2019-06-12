//
//  Pokemon.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: Int?
    var name: String?
    var username: String?
    var password: String?
    
    init(id: Int, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}
