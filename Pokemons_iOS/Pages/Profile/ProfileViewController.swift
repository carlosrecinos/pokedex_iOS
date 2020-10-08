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
        let tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile_icon"), tag: 0)
        
        self.tabBarItem = tabBarItem
        self.tabBarController?.tabBar.tintColor = UIColor.pokeRed
        self.tabBarController?.tabBar.isTranslucent = true
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
        let keychain = KeychainManager()
        do {
            try keychain.deleteToken(username: "recinos")
        } catch {
            
        }
        
    }
}
