//
//  MainAssembly.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import Swinject

class MainAssembly: Assembly {
    func assemble(container: Container) {
        // Networking
        container.register(HttpNetworking.self) { _ in
            return AlamofireNetworking()
        }
        
        // AuthenticationService
        container.register(AuthenticationServiceProtocol.self) { resolver in
            let authenticationService = AuthenticationService()
            let networking = resolver.resolve(HttpNetworking.self)!
            let keychain = KeychainManager()
            authenticationService.inject(networking: networking, keychainManager: keychain)
            return authenticationService
        }
        
        // PokemonService
        container.register(PokemonServiceProtocol.self) { resolver in
            let pokemonService = PokemonService()
            let networking = resolver.resolve(HttpNetworking.self)!
            pokemonService.inject(networking: networking)
            return pokemonService
        }
        registerLoginPage(to: container)
        registerPokemonListPage(to: container)
    }
    
    func registerLoginPage(to container: Container) {
        container.storyboardInitCompleted(LoginViewController.self) {(resolver, viewController) in
            var presenter = resolver.resolve(LoginPresenterProtocol.self)!
            presenter.loginView = viewController
            viewController.inject(presenter: presenter)
        }
        
        container.register(LoginPresenterProtocol.self) { resolver in
            let interactor = resolver.resolve(LoginInteractorProtocol.self)!
            let presenter = LoginPresenter()
            presenter.inject(interactor: interactor)
            return presenter
        }
        
        container.register(LoginInteractorProtocol.self) { resolver in
            let interactor = LoginInteractor()
            let authentication = resolver.resolve(AuthenticationServiceProtocol.self)!
            interactor.inject(authentication: authentication)
            return interactor
            }
            .initCompleted { resolver, interactor in
                var loginInteractor = interactor
                loginInteractor.loginPresenter = resolver.resolve(LoginPresenterProtocol.self)!
        }
        
    }
    
    func registerPokemonListPage(to container: Container) {
        container.storyboardInitCompleted(PokemonListViewController.self) { (resolver, pokemonListViewController) in
            
            var presenter = resolver.resolve(PokemonListPresenterProtocol.self)!
            presenter.pokemonListViewController = pokemonListViewController
            pokemonListViewController.inject(presenter: presenter)
        }
        
        container.register(PokemonListPresenterProtocol.self) { resolver in
            let interactor = resolver.resolve(PokemonListInteractor.self)!
            let presenter = PokemonListPresenter()
            presenter.inject(interactor: interactor)
            return presenter
        }
        
        container.register(PokemonListInteractor.self) {resolver in
            let interactor = PokemonListInteractor()
            let pokemonService = resolver.resolve(PokemonServiceProtocol.self)!
            interactor.inject(pokemonsService: pokemonService)
            return interactor
        }
            .initCompleted { resolver, interactor in
                let pokemonListInteractor = interactor
                pokemonListInteractor.pokemonListPresenter = resolver.resolve(PokemonListPresenterProtocol.self)
        }
    }
    
}
