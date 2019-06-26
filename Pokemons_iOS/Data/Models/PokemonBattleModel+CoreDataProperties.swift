//
//  PokemonBattleModel+CoreDataProperties.swift
//  
//
//  Created by Carlos Recinos on 6/26/19.
//
//

import Foundation
import CoreData


extension PokemonBattleModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonBattleModel> {
        return NSFetchRequest<PokemonBattleModel>(entityName: "PokemonBattleModel")
    }

    @NSManaged public var dateStarted: NSDate?
    @NSManaged public var score: Int16
    @NSManaged public var round: Int16
    @NSManaged public var pokemon_battle: PokemonModel?

}
