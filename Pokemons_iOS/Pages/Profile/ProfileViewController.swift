//
//  ProfileViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
        
    @IBAction func signOutButtonPressed(_ sender: Any) {
        print("Log out")
        logOut()
        goToMain()
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
