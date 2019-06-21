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
    var detail: PokemonDetail?
    
    func getPokemonId() -> Int? {
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
    var types: [Types]?
    var height: Int?
    var stats: [PokemonStats]
    var sprites: Sprites?
    var measureUnits: MeasureUnits?
    var abilities: [Abilities]
}

struct Abilities: Decodable {
    var ability: Ability
    var is_hidden: Bool
    var slot: Int
}

struct Ability: Decodable {
    var name: String
    var url: String
}

struct Types: Decodable {
    var slot: Int
    var type: Type
}

struct Type: Decodable {
    var name: String
    var url: String
}

struct Sprites: Decodable, Loopable {
    var back_default: String?
    var back_female: String?
    var back_shiny: String?
    var back_shiny_female: String?
    var front_default: String?
    var front_female: String?
    var front_shiny: String?
    var front_shiny_female: String?
    
    func getSprites() -> [String: String] {
        var dictionary: [String: String] = [:]
        do {
            let temporalDictionary = try self.allProperties()
            for (key, value) in temporalDictionary {
                dictionary[key] = value as? String
            }
        } catch let error {
            print("Error getting sprites", error)
        }
        return dictionary
    }
}

struct PokemonStats: Decodable {
    var base_stat: Int
    var effort: Int
    var stat: Stat
}

struct Stat: Decodable {
    var name: String?
    var url: String?
}

struct MeasureUnits: Decodable {
    static var height =  "Dm"
    static var weight = "Hg"
}

protocol Loopable {
    func allProperties() throws -> [String: Any]
}

extension Loopable {
    func allProperties() throws -> [String: Any] {
        
        var result: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            result[property] = value
        }
        
        return result
    }
}
