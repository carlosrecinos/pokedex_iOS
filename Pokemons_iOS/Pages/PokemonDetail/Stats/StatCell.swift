//
//  StatCell.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/20/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit

class StatCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    var stat: PokemonStats?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ pokemonStat: PokemonStats) {
        stat = pokemonStat
        configureUI()
        displayData()
    }
    
    func configureUI() {
        configureCellBorder()
        configureSlider()
    }
    
    func displayData() {
        nameLabel.text = stat?.stat.name
        valueLabel.text = String(stat?.base_stat ?? 0)
        let decimalValue = Float(stat?.base_stat ?? 0) / 100
        valueSlider.value = decimalValue
    }
    
    
    
    func configureSlider() {
        valueSlider?.minimumTrackTintColor = UIColor.pokeYellow
        valueSlider?.maximumTrackTintColor = UIColor.pokeYellowDarker
        
//        let thumbImage = UIImage(named: "pokeballs_red")
//        valueSlider?.setThumbImage(thumbImage?.resizeImage(newWidth: 16), for: .normal)
    }
    
    func configureCellBorder() {
        let border = CALayer()
        let width = CGFloat(0.0)
        border.borderColor = UIColor.pokeRedAccentDarker.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
