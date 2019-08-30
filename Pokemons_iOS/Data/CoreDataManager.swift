//
//  CoreDataManager.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/24/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonsData")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            if let error = error {
                fatalError("Could not load container: \(error)")
            }
        })
        return container
    }()
    
    init() {
        
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = persistentContainer.viewContext
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
             print("ERRRORR \(error)")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("\(error)")
            }
        }
    }
    
}
