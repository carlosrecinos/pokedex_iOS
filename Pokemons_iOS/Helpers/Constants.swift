//
//  Constants.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation

enum ApiRequests: String {
    
    func getPokemons(offset: Int, limit: Int) -> String {
        return "https://recinospokedex.herokuapp.com/api/pokemon/?\(offset)=0&limit=\(limit)"
    }

    func getPokemonById(pokemonId: Int) -> String {
        return "https://recinospokedex.herokuapp.com/api/pokemon/\(pokemonId)"
    }
    case signIn = "https://recinospokedex.herokuapp.com/api/pokemon"
}

