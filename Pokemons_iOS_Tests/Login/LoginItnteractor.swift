//
//  Pokemons_iOS_Tests.swift
//  Pokemons_iOS_Tests
//
//  Created by Carlos Recinos on 6/6/19.
//  Copyright © 2019 genui. All rights reserved.
//
import Quick
import Nimble

@testable import Pokemons_iOS

class LoginInteractor: QuickSpec {
    
    override func spec() {
        describe("LoginViewController") {
            var presenter: LoginPresenterProtocol!
            var subject: LoginViewController!
            beforeEach {
                presenter = LoginPresenter()
                subject = LoginViewController()
                subject.inject(presenter: presenter)
            }
            
            context("When didLoad is called") {
                beforeEach {
//                    presenter.st
                }
            }
        }
    }

}
