//
//  PokemonListPresenter.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/9/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import CoreData

protocol PokemonListPresenterProtocol {
    var pokemonListViewController: PokemonListViewControllerProtocol? { get set }
    func updateAllPokemonsList(pokemons: NSFetchedResultsController<PokemonModel>)
    func updateOwnedPokemonsList(pokemons: [Pokemon])
    func showError(error: PokemonServiceError)
    func fetchPokemons(type: PokemonsListTypes)
    func loadLocalPokemons()
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    
    var pokemonListViewController: PokemonListViewControllerProtocol?
    var pokemonListInteractor: PokemonListInteractorProtocol?
    
    var allPokemons: [Pokemon] = []
    
    func inject(interactor: PokemonListInteractorProtocol) {
        pokemonListInteractor = interactor
    }
    
    func loadLocalPokemons() {
        pokemonListInteractor?.loadLocalPokemons()
    }
    
    func fetchPokemons(type: PokemonsListTypes) {
        switch type {
        case .allPokemons:
            print("to fetch all")
            pokemonListInteractor?.fetchPokemons()
        case .ownedPokemons:
            print("to fetch owned")
            var poks = [
                Pokemon(id: 1, name: "ASD", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                        Pokemon(id: 2, name: "ASD2", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
            updateOwnedPokemonsList(pokemons: poks)
        }
    }
    
    func updateAllPokemonsList(pokemons: NSFetchedResultsController<PokemonModel>) {
        pokemonListViewController?.updatePokemonsList(pokemons: pokemons, type: .allPokemons)
    }
    
    func updateOwnedPokemonsList(pokemons: [Pokemon]) {
//        pokemonListViewController?.updatePokemonsList(pokemons: pokemons, type: .ownedPokemons)
    }
    
    func showError(error: PokemonServiceError) {
        print(error)
    }
    
}
