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
    var detail: PokemonDetail
    
    private func getPokemonId() -> Int? {
        let urlWithouLastSlash = url.dropLast()
        let idIndex = url.index(after: urlWithouLastSlash.lastIndex(of: "/")!)
        let range = idIndex..<urlWithouLastSlash.endIndex
        let id = urlWithouLastSlash[range]
        return Int(id)
    }
    
    func getImageUrl() -> String {
        let baseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        let pokemonId = getPokemonId()
        let imageUrl = "\(baseUrl)\(pokemonId ?? 1).png"
        return imageUrl
    }
}

struct PokemonDetail: Decodable {
    var generation: Int
    var type: String
    var height: Int?
    var stats: PokemonStats?
    var sprites: Sprites?
    var measureUnits: MeasureUnits
}

struct Sprites: Decodable {
    var back_default: String?
    var back_female: String?
    var back_shiny: String?
    var back_shiny_female: String?
    var front_default: String?
    var front_female: String?
    var front_shiny: String?
    var front_shiny_female: String?
}

struct PokemonStats: Decodable {
    var base_stat: Int?
    var effort: Int?
    var stat: Stat?
}

struct Stat: Decodable {
    var name: String?
    var url: String?
}

struct MeasureUnits: Decodable {
    static var height =  "Dm"
    static var weight = "Hg"
}
