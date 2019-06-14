//
//  LoginInteractor.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/9/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures

protocol LoginInteractorProtocol {
    var loginPresenter: LoginPresenterProtocol? { get set }
    func signIn(_ username: String, _ password: String)
}

class LoginInteractor: LoginInteractorProtocol {
    var loginPresenter: LoginPresenterProtocol?
    var authentication: AuthenticationServiceProtocol?
    
    func inject(authentication: AuthenticationServiceProtocol) {
        self.authentication = authentication
    }
    
    func signIn(_ username: String, _ password: String){
        authentication?.signIn(username, password)
            .onSuccess(callback: { user in
                self.loginPresenter?.goToMain()
            })
            .onFailure(callback: { error in
                self.loginPresenter?.showAuthFailedErrorMessage()
            })
    }
}
