//
//  CatchPokemonViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/25/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit



class CatchPokemonViewController: UIViewController {

    var pokemonToCatch: PokemonModel?
    var pokemonStruct: Pokemon?
    var pokemonBattle: PokemonBattleModel?
    var coreDataManager: CoreDataManager?
    
    @IBOutlet weak var pokeballSlider: StatsPokemonSlider?
    @IBOutlet weak var infoContainer: UIView?
    @IBOutlet weak var goalLabel: UILabel?
    @IBOutlet weak var currentScoreLabel: UILabel?
    @IBOutlet weak var roundLabel: UILabel?
    @IBOutlet weak var pokemonImage: UIImageView?
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBattleArena()
        pokemonStruct = pokemonToCatch?.getStruct()
    }
    
    func inject(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func configureBattleArena() {
        configureLayout()
        initRound()
    }
    
    func configureLayout() {
        
        let infoButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(showCatchPokemonInfo(_:)))
        
        navigationItem.rightBarButtonItem = infoButton
        
        if let pokemonImageUrl = pokemonStruct?.getImageUrl() {
            let size = CGSize(width: 200, height: 200)
            pokemonImage?.imageFromURL(urlString: pokemonImageUrl, withSize: size)
        }
        
        infoContainer?.layer.cornerRadius = 20
        infoContainer?.clipsToBounds = true
        
        goButton?.layer.cornerRadius = 8
        goButton?.clipsToBounds = true
        
        configureSlider()
    }
    
    func configureSlider() {
        pokeballSlider?.minimumTrackTintColor = UIColor.pokeYellow
        pokeballSlider?.maximumTrackTintColor = UIColor.pokeYellowDarker
        
        pokeballSlider?.minimumValue = 0
        pokeballSlider?.maximumValue = 100
        
        let thumbImage = UIImage(named: "pokeballs_red")?.resizeImage(newWidth: 32)
        pokeballSlider?.setThumbImage(thumbImage, for: .normal)
    }
    
    func initRound() {
        if let battle = pokemonBattle {
            loadPrevBattle(battle)
        } else {
            loadNewBattle()
        }
    }
    
    func loadPrevBattle(_ battle: PokemonBattleModel) {
        
    }
    
    func loadNewBattle() {
        
        pokemonBattle?.round = 1
        pokemonBattle?.score = 0
        pokemonBattle?.dateStarted = Date() as NSDate
        
        let round: Int16 = pokemonBattle?.round ?? 1
        let score: Int16 = pokemonBattle?.score ?? 0
        let goalValue = getRandomNumber()
        
        roundLabel?.text = String(Int(round))
        currentScoreLabel?.text = String(Int(score))
        goalLabel?.text = String(goalValue)
        
        resetSlider()
        
    }
    
    func resetSlider() {
        pokeballSlider?.value = Float(getRandomNumber()).rounded()
    }
    
    @objc func showCatchPokemonInfo(_ button: UIBarButtonItem) {
        performSegue(withIdentifier: "CatchPokemonHelpSegue", sender: nil)
    }
    
    func getRandomNumber() -> Int {
        return Int.random(in: 0...100)
    }
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        print("Value: \(pokeballSlider?.value)")
    }
}
