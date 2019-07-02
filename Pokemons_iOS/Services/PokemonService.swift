//
//  PokemonService.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures
import CoreData

enum PokemonServiceError: Error {
    case notFound
    case serviceError
    case decodingFailure
}

protocol PokemonServiceProtocol {
    func fetchPokemons() -> Future<NSFetchedResultsController<PokemonModel>?, PokemonServiceError>
    func fetchPokemon(_ id: Int) -> Future<PokemonDetail, PokemonServiceError>
    func loadLocalPokemons() -> NSFetchedResultsController<PokemonModel>?
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
    
    func loadLocalPokemons() -> NSFetchedResultsController<PokemonModel>? {
        
        //Before implementing this solution the app was using 64 MB of RAM
        guard let context = coreDataManager?.persistentContainer.viewContext else {
            return nil
        }
        
        let request = PokemonModel.fetchRequest() as NSFetchRequest<PokemonModel>
        let sortById = NSSortDescriptor(key: #keyPath(PokemonModel.id), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sortById]
        
        let fetchedPokemonsRS: NSFetchedResultsController<PokemonModel>
        do {
            fetchedPokemonsRS = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedPokemonsRS.performFetch()
            return fetchedPokemonsRS
        } catch let error as NSError {
            print("Fatal error: \(error)")
        }
        return nil
    }
    
    func fetchPokemons() -> Future<NSFetchedResultsController<PokemonModel>?, PokemonServiceError> {
        
        let pokemonsFromCoreData = getCoreDataPokemons()
        let offset = pokemonsFromCoreData?.count ?? 0
        let limit = 29
        
        let promise = Promise<NSFetchedResultsController<PokemonModel>?, PokemonServiceError>()
        let url = "\(Constants.baseUrl)/api/pokemon/?offset=\(offset)&&limit=\(limit)"
        
        networking?.request(url: url)
            .onSuccess(callback: { response in
                if let jsonData = response.data {
                    do {
                        let pokemonsResponse = try JSONDecoder().decode(PokemonsApiResponse.self, from: jsonData)
                        let pokemons = pokemonsResponse.data?.results!
                        if let pokemons = pokemons {
                            self.savePokemonsToCoreData(pokemons)
                            let newPokemons = self.loadLocalPokemons()
                            promise.success(newPokemons)
                        } else {
                            promise.failure(.serviceError)
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
