//
//  LoginPresenter.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/9/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
    var loginView: LoginViewControllerProtocol? { get set }
    
    func signIn(_ username: String?, _ password: String?)
    func showEmptyFieldsErrorMessage()
    func showAuthFailedErrorMessage()
    func goToMain()
}

class LoginPresenter: LoginPresenterProtocol {
    var loginView: LoginViewControllerProtocol?
    var loginInteractor: LoginInteractorProtocol?
    
    func inject(interactor: LoginInteractorProtocol) {
        loginInteractor = interactor
    }
    
    func signIn(_ username: String?, _ password: String?) {
        if areFieldsFilled(username, password) {
            loginView?.setLoadingStatus(to: true)
            loginInteractor?.signIn(username!, password!)
        } else {
            showEmptyFieldsErrorMessage()
        }
    }
    
    func areFieldsFilled(_ username: String?, _ password: String?) -> Bool {
        let isUsernameFieldFilled = (username != nil) && (username != "")
        let isPasswordFieldFilled = (password != nil) && (password != "")
        return isUsernameFieldFilled && isPasswordFieldFilled
    }
    
    func showAuthFailedErrorMessage() {
        loginView?.showErrorMessage(message: "Authentication failed")
    }
    
    func goToMain() {
        loginView?.goToMain()
    }
    
    func showEmptyFieldsErrorMessage() {
        loginView?.showErrorMessage(message: "Empty Fields")
    }
}
