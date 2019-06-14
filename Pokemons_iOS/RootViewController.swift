//
//  RootViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/14/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var keychainManager: KeychainManager?
    var loginPage: LoginViewController?
    var mainPage: PokemonListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectViewToShow()
    }
    
    func selectViewToShow() {
        var pageToShow: UIViewController
        if(isLogged()) {
            pageToShow = mainPage!
        } else {
            pageToShow = loginPage!
        }
        
        present(pageToShow, animated: true, completion: nil)
    }
    
    func isLogged() -> Bool {
        
//        let isTokenSaved =
//        return
        return true
    }
}
