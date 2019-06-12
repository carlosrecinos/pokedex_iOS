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
    func fetchPokemons(offset: Int, limit: Int)
}

class PokemonListInteractor: PokemonListInteractorProtocol {
    var pokemonsService: PokemonServiceProtocol?
    var pokemonListPresenter: PokemonListPresenterProtocol?
    
    func inject(pokemonsService: PokemonServiceProtocol) {
        self.pokemonsService = pokemonsService
    }
    
    func fetchPokemons(offset: Int, limit: Int) {
        
        pokemonsService?.fetchPokemons(offset: offset, limit: limit)
            .onSuccess(callback: { pokemons in
                self.pokemonListPresenter?.updatePokemonsList(pokemons: pokemons)
            })
        .onFailure(callback: { error in
            print(error)
            self.pokemonListPresenter?.showError(error: .serviceError)
        })
    }
    
}
