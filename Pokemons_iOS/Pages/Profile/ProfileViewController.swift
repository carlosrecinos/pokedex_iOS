//
//  ProfileViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileViewControllerProtocol {
    func inject(coreDataManager: CoreDataManager)
}

class ProfileViewController: UIViewController {
    
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        navigationItem.title = "Profile"
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteCoreData(_:)))
        
        navigationItem.rightBarButtonItem = trashButton
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        print("Log out")
        logOut()
        goToMain()
    }
    
    func inject(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    @objc func deleteCoreData(_ some: UIBarButtonItem) {
        print(some)
        coreDataManager?.deleteAllData("PokemonModel")
    }
    
    func goToMain() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    func logOut() {
        let preferences = UserDefaults.standard
        preferences.set(false, forKey: "isLogged")
    }
}
