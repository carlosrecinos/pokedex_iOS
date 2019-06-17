//
//  PokemonDetailViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/14/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    var selectedPokemon: Pokemon?
    
    @IBOutlet var nameLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        loadPokemonInfo()
        // Do any additional setup after loading the view.
    }
    
    func initConfig() {
        navigationController?.view.backgroundColor = UIColor.groupTableViewBackground
        self.navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem(title: "< Pokemons", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        if let pokemonFont = UIFont(name: "Pokemon Solid", size: 20) {
            print("new font")
            backButton.setTitleTextAttributes([NSAttributedString.Key.font: pokemonFont], for: UIControl.State.normal)
            
        }
        
        self.navigationItem.leftBarButtonItem?.title = nil
        self.navigationItem.backBarButtonItem?.title = nil
        
    }
    
    func loadPokemonInfo() {
        nameLabel?.text = "selectedPokemon?.name"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
