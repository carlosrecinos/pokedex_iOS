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
        // CoreData
        
        container.register(CoreDataManager.self, factory: { _ in
            return CoreDataManager()
        }).inObjectScope(.container)
        
        
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
            let coreDataManager = resolver.resolve(CoreDataManager.self)!
            pokemonService.inject(networking: networking, coreDataManager: coreDataManager)
            return pokemonService
        }
        
        
        registerLoginPage(to: container)
        registerPokemonListPage(to: container)
        registerPokemonDetailPage(to: container)
        registerRootPage(to: container)
        registerProfilePage(to: container)
    }
    
    func registerRootPage(to container: Container) {
        container.storyboardInitCompleted(RootViewController.self) { (resolver, viewController) in
            let loginPage = resolver.resolve(LoginViewController.self)
            let mainPage = resolver.resolve(PokemonListViewController.self)
            let keychainManager = resolver.resolve(KeychainManager.self)
            viewController.keychainManager = keychainManager
            viewController.mainPage = mainPage
            viewController.loginPage = loginPage
        }
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
    
    func registerPokemonDetailPage(to container: Container) {
        container.storyboardInitCompleted(PokemonDetailViewController.self) { (resolver, pokemonDetailViewController) in
            var presenter = resolver.resolve(PokemonDetailPresenterProtocol.self)!
            presenter.pokemonDetailViewController = pokemonDetailViewController
            pokemonDetailViewController.inject(presenter: presenter)
        }
        
        container.register(PokemonDetailPresenterProtocol.self) { resolver in
            let interactor = resolver.resolve(PokemonDetailInteractor.self)!
            let presenter = PokemonDetailPresenter()
            presenter.inject(interactor: interactor)
            return presenter
        }
        
        container.register(PokemonDetailInteractor.self) {resolver in
            let interactor = PokemonDetailInteractor()
            let pokemonService = resolver.resolve(PokemonServiceProtocol.self)!
            interactor.inject(pokemonService)
            return interactor
            }
            .initCompleted { resolver, interactor in
                let pokemonDetailInteractor = interactor
                
                pokemonDetailInteractor.pokemonDetailPresenter = resolver.resolve(PokemonDetailPresenterProtocol.self)
        }
    }
    
    func registerProfilePage(to container: Container) {
        container.storyboardInitCompleted(ProfileViewController.self) {(resolver, viewController) in
            let coreDataManager = resolver.resolve(CoreDataManager.self)!
            viewController.inject(coreDataManager: coreDataManager)
        }
        
    }
    
}
