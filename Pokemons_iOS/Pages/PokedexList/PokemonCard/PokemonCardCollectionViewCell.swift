//
//  PokemonCardCollectionViewCell.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/24/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit

class PokemonCardCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(_ pokemon: Pokemon) {
        configureLayout()
        let imageUrl = pokemon.getImageUrl()
        pokemonImage.imageFromURL(urlString: imageUrl, withSize: CGSize(width: 100, height: 100))
        
        pokemonNameLabel.text = pokemon.name
    }
    
    func configureLayout() {
        
        cardContainer.clipsToBounds = true
        
        cardContainer.layer.cornerRadius = 20.0
        
        
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.5
        cardContainer.layer.shadowOffset = CGSize(width: 100, height: 100)
        cardContainer.layer.shadowRadius = 100
        
        cardContainer.layer.shadowPath = UIBezierPath(rect: cardContainer.bounds).cgPath
        cardContainer.layer.shouldRasterize = true
        
        
    }

}
