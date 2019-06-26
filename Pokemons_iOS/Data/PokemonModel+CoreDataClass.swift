//
//  PokemonModel+CoreDataClass.swift
//  
//
//  Created by Carlos Recinos on 6/26/19.
//
//

import Foundation
import CoreData


public class PokemonModel: NSManagedObject {
    func getStruct() -> Pokemon {
        let pokemon = Pokemon(id: Int(self.id), name: self.name!, url: self.url!)
        return pokemon
    }
}
