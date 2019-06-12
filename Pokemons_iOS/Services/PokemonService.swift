//
//  PokemonService.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures

enum PokemonServiceError: Error {
    case notFound
    case serviceError
    case decodingFailure
}

protocol PokemonServiceProtocol {
    func fetchPokemons(offset: Int, limit: Int) -> Future<[Pokemon], PokemonServiceError>
//    func fetchPokemon(pokemonId: Int) -> Future<[Pokemon], PokemonServiceError>
}

class PokemonService: PokemonServiceProtocol {
    var networking: HttpNetworking?
    
    func inject(networking: HttpNetworking) {
        self.networking = networking
    }
    
    func fetchPokemons(offset: Int, limit: Int) -> Future<[Pokemon], PokemonServiceError> {
        let promise = Promise<[Pokemon], PokemonServiceError>()
        let url = "https://recinospokedex.herokuapp.com/api/pokemon/?offset=\(offset)&&limit=\(limit)"
        
        networking?.request(url: url)
            .onSuccess(callback: { response in
                if let jsonData = response.data {
                    do {
                        let pokemonsResponse = try JSONDecoder().decode(PokemonsResponse.self, from: jsonData)
                        let pokemons = pokemonsResponse.data?.results!
                        if let pokemons = pokemons {
                            promise.success(pokemons)
                        } else {
                            promise.success([])
                        }
                    } catch {
                        promise.failure(.decodingFailure)
                    }
                } else {
                    promise.failure(.serviceError)
                }
            })
            .onFailure { error in
                print(error)
        }
        return promise.future
    }
    
//    func fetchPokemon(pokemonId: Int) -> Future<[Pokemon], PokemonServiceError> {
//
//    }
}
