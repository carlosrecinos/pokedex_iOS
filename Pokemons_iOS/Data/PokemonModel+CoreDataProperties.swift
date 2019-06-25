//
//  PokemonModel+CoreDataProperties.swift
//  
//
//  Created by Carlos Recinos on 6/25/19.
//
//

import Foundation
import CoreData


extension PokemonModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonModel> {
        return NSFetchRequest<PokemonModel>(entityName: "PokemonModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var id: Int16
    @NSManaged public var caught: Bool

}
