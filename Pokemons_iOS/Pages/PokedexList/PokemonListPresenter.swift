//
//  PokemonListPresenter.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/9/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation

protocol PokemonListPresenterProtocol {
    var pokemonListViewController: PokemonListViewControllerProtocol? { get set }
    func updatePokemonsList(pokemons: [Pokemon])
    func showError(error: PokemonServiceError)
    func fetchPokemons()
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    
    var pokemonListViewController: PokemonListViewControllerProtocol?
    var pokemonListInteractor: PokemonListInteractorProtocol?
    var offset = 0
    var limit = 29
    
    func inject(interactor: PokemonListInteractorProtocol) {
        pokemonListInteractor = interactor
    }
    
    func fetchPokemons() {
        pokemonListInteractor?.fetchPokemons(offset: offset, limit: limit)
    }
    
    func updatePokemonsList(pokemons: [Pokemon]) {
        updateOffsetCounter()
        pokemonListViewController?.updatePokemonsList(pokemons: pokemons)
    }
    
    func updateOffsetCounter() {
        offset += limit + 2
        
    }
    
    func showError(error: PokemonServiceError) {
        print(error)
    }
    
}
