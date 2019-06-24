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
    func updateAllPokemonsList(pokemons: [Pokemon])
    func updateOwnedPokemonsList(pokemons: [Pokemon])
    func showError(error: PokemonServiceError)
    func fetchPokemons(type: PokemonsListTypes)
    func updateOffsetCounter()
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    
    var pokemonListViewController: PokemonListViewControllerProtocol?
    var pokemonListInteractor: PokemonListInteractorProtocol?
    var offset = 0
    var limit = 29
    
    var allPokemons: [Pokemon] = []
    
    func inject(interactor: PokemonListInteractorProtocol) {
        pokemonListInteractor = interactor
    }
    
    func fetchPokemons(type: PokemonsListTypes) {
        switch type {
        case .allPokemons:
            print("to fetch all")
            pokemonListInteractor?.fetchPokemons(offset: offset, limit: limit)
        case .ownedPokemons:
            print("to fetch owned")
            var poks = [
                Pokemon(id: 1, name: "ASD", url: "https://pokeapi.co/api/v2/pokemon/1/", detail: nil),
                        Pokemon(id: 2, name: "ASD2", url: "https://pokeapi.co/api/v2/pokemon/2/", detail: nil)
            ]
            poks = [Pokemon(id: 1, name: "Chicorita", url: "https://pokeapi.co/api/v2/pokemon/30/", detail: nil)]
            updateOwnedPokemonsList(pokemons: poks)
        }
    }
    
    func updateAllPokemonsList(pokemons: [Pokemon]) {
        pokemonListViewController?.updatePokemonsList(pokemons: pokemons, type: .allPokemons)
    }
    
    func updateOwnedPokemonsList(pokemons: [Pokemon]) {
        pokemonListViewController?.updatePokemonsList(pokemons: pokemons, type: .ownedPokemons)
    }
    
    func updateOffsetCounter() {
        offset += limit + 2
    }
    
    func showError(error: PokemonServiceError) {
        print(error)
    }
    
}
