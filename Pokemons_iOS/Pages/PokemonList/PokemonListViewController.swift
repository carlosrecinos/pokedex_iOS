//
//  PokemonListViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

protocol PokemonListViewControllerProtocol {
    func updatePokemonsList(pokemons: [Pokemon])
}

class PokemonListViewController: UIViewController, PokemonListViewControllerProtocol {
    
    
    @IBOutlet weak var isLoggedVarLabel: UILabel!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    var pokemonListPresenter: PokemonListPresenterProtocol?
    var pokemonsList: [Pokemon] = []
    
    
    func inject(presenter: PokemonListPresenterProtocol) {
        pokemonListPresenter = presenter
    }
    
    override func viewDidLoad() {
        pokemonListPresenter?.fetchPokemons()
        setInitConfig()
    }
    
    func setInitConfig() {
        pokemonListCollectionView.dataSource = self
        pokemonListCollectionView.delegate = self
        let width = (view.frame.size.width - 20) / 3
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 1.2)
    }
    
    func updatePokemonsList(pokemons: [Pokemon]) {
        pokemonsList = pokemons
        print("To render")
        pokemonListCollectionView.reloadData()
    }
    
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("HEHE \(pokemonsList.count)")
        return pokemonsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCell", for: indexPath)
        if let pokemonNameLabel = cell.viewWithTag(1) as? UILabel {
            pokemonNameLabel.text = pokemonsList[indexPath.row].name
        }
        print("HEHE 2 \(pokemonsList.count)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemonsList[indexPath.row]
        print("pokemon selected: \(selectedPokemon.name)")
    }
}
