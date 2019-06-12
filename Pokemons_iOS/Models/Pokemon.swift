//
//  Pokemon.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation

struct Pokemon: Decodable {
    var id: Int?
    var name: String
    var url: String
    
    func getPokemonId() -> Int? {
        let urlWithouLastSlash = url.dropLast()
        let idIndex = url.index(after: urlWithouLastSlash.lastIndex(of: "/")!)
        let range = idIndex..<urlWithouLastSlash.endIndex
        let id = urlWithouLastSlash[range]
        return Int(id)
    }
}
