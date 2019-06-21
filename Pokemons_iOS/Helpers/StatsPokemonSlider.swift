//
//  StatsPokemonSlider.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/21/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

class StatsPokemonSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 8
        return rect
    }
}
