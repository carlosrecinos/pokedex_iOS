//
//  PokemonListInteractor.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/9/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures

protocol PokemonListInteractorProtocol {
    func fetchPokemons()
    func loadLocalPokemons()
}

class PokemonListInteractor: PokemonListInteractorProtocol {
    var pokemonsService: PokemonServiceProtocol?
    var pokemonListPresenter: PokemonListPresenterProtocol?
    
    func inject(pokemonsService: PokemonServiceProtocol) {
        self.pokemonsService = pokemonsService
    }
    
    
    func loadLocalPokemons() {
        let pokemons = pokemonsService?.loadLocalPokemons()
        if let pokemons = pokemons, pokemons.fetchedObjects?.count ?? 0 > 0 {
            pokemonListPresenter?.updateAllPokemonsList(pokemons: pokemons)
        } else {
            fetchPokemons()
        }
    }
    
    func fetchPokemons() {
        pokemonsService?.fetchPokemons()
            .onSuccess(callback: { pokemons in
                if let pokemons = pokemons {
                    self.pokemonListPresenter?.updateAllPokemonsList(pokemons: pokemons)
                }
            })
        .onFailure(callback: { error in
            print(error)
            self.pokemonListPresenter?.showError(error: .serviceError)
        })
    }
    
}
