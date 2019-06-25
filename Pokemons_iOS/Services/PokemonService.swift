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
    func fetchPokemons() -> Future<[Pokemon], PokemonServiceError>
    func fetchPokemon(_ id: Int) -> Future<PokemonDetail, PokemonServiceError>
    func loadLocalPokemons() -> [Pokemon]
}

class PokemonService: PokemonServiceProtocol {
    var networking: HttpNetworking?
    var coreDataManager: CoreDataManager?
    
    func inject(networking: HttpNetworking, coreDataManager: CoreDataManager) {
        self.networking = networking
        self.coreDataManager = coreDataManager
    }
    
    func getCoreDataPokemons() -> [Any]? {
        let context = coreDataManager?.persistentContainer.viewContext
        var pokemonsFromCoreData: [Any]? = []
        do {
            pokemonsFromCoreData = try context?.fetch(PokemonModel.fetchRequest())
        } catch {
            let error = error as NSError
            fatalError("\(error)")
        }
        
        return pokemonsFromCoreData
    }
    
    func savePokemonsToCoreData(_ pokemons: [Pokemon]) {
        let context = coreDataManager?.persistentContainer.viewContext
        var currentPokemons = getCoreDataPokemons()
        for pokemon in pokemons {
            let pokemonModel = PokemonModel(entity: PokemonModel.entity(), insertInto: context)
            pokemonModel.name = pokemon.name
            pokemonModel.url = pokemon.url
            pokemonModel.id = pokemon.getPokemonId()!
            currentPokemons?.append(pokemonModel)
        }
        
        coreDataManager?.saveContext()
        
    }
    
    func convertFromModelToStruct(_ pokemons: [Any]?) -> [Pokemon] {
        var pokemonsStructs: [Pokemon] = []
        if let pokemons = pokemons {
            for pokemon in pokemons {
                let castedPokemon = pokemon as! PokemonModel
                pokemonsStructs.append(Pokemon(from: castedPokemon))
            }
        }
        return pokemonsStructs
    }
    
    func loadLocalPokemons() -> [Pokemon] {
        let coreDataPokemons = getCoreDataPokemons()
        let pokemons = convertFromModelToStruct(coreDataPokemons)
        return pokemons
    }
    
    func fetchPokemons() -> Future<[Pokemon], PokemonServiceError> {
        
        let pokemonsFromCoreData = getCoreDataPokemons()
        let offset = pokemonsFromCoreData?.count ?? 0
        let limit = 29
        
        let promise = Promise<[Pokemon], PokemonServiceError>()
        let url = "\(Constants.baseUrl)/api/pokemon/?offset=\(offset)&&limit=\(limit)"
        
        networking?.request(url: url)
            .onSuccess(callback: { response in
                if let jsonData = response.data {
                    do {
                        let pokemonsResponse = try JSONDecoder().decode(PokemonsApiResponse.self, from: jsonData)
                        let pokemons = pokemonsResponse.data?.results!
                        if let pokemons = pokemons {
                            self.savePokemonsToCoreData(pokemons)
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
        let url = "\(Constants.baseUrl)/api/pokemon/\(id)"
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
