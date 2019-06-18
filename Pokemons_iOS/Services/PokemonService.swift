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
    func fetchPokemon(_ id: Int) -> Future<PokemonDetail, PokemonServiceError>
}

class PokemonService: PokemonServiceProtocol {
    var networking: HttpNetworking?
    
    func inject(networking: HttpNetworking) {
        self.networking = networking
    }
    
    func fetchPokemons(offset: Int, limit: Int) -> Future<[Pokemon], PokemonServiceError> {
        let promise = Promise<[Pokemon], PokemonServiceError>()
        let url = "\(HelperStrings.baseUrl)/api/pokemon/?offset=\(offset)&&limit=\(limit)"
        
        networking?.request(url: url)
            .onSuccess(callback: { response in
                if let jsonData = response.data {
                    do {
                        
                        let pokemonsResponse = try JSONDecoder().decode(PokemonsApiResponse.self, from: jsonData)
                        let pokemons = pokemonsResponse.data?.results!
                        if let pokemons = pokemons {
                            promise.success(pokemons)
                        } else {
                            promise.success([])
                        }
                    } catch let error {
                        print(error)
                        promise.failure(.decodingFailure)
                    }
                } else {
                    promise.failure(.serviceError)
                }
            })
            .onFailure { error in
                print("errorASASD")
        }
        return promise.future
    }
    
    func fetchPokemon(_ id: Int) -> Future<PokemonDetail, PokemonServiceError> {
        let promise = Promise<PokemonDetail, PokemonServiceError>()
        let url = "\(HelperStrings.baseUrl)/api/pokemon/\(id)"
        networking?.request(url: url)
            .onSuccess(callback: { response in
                if let jsonData = response.data {
                    do {
                        let detailResponse = try JSONDecoder().decode(PokemonDetailApiResponse.self, from: jsonData)
                        let pokemonDetail = detailResponse.data
                        promise.success(pokemonDetail)
                    } catch let error {
                        print(error)
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
}
