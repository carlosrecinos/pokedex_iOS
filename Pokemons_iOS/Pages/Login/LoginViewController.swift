//
//  LoginViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

struct BackgroundAnimation {
    let duration = 10.0
    let rotation = 380
}

struct PokeballsAnimation {
    let duration = 0.5
    let initialSpringVelocity = 10.0
    let usingSpringWithDamping = 10
}

protocol LoginViewControllerProtocol {
    func showErrorMessage(message: String)
    func goToMain()
    func setLoadingStatus(to status: Bool)
}

struct PokeballAnimationHandler {
    var initialPosition: CGFloat
    var imageView: UIImageView?
}

class LoginViewController: UIViewController, LoginViewControllerProtocol{

    var loginPresenter: LoginPresenterProtocol?
    var username: String?
    var password: String?
    var loading = false
    var pokeballs: [PokeballAnimationHandler] = []
    let backgroundAnimation = BackgroundAnimation()
    let pokeballsAnimation = PokeballsAnimation()
    
    @IBOutlet weak var loginBackgroundImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameInputText: UITextField!
    @IBOutlet weak var passwordInputText: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var bluePokeballImageView: UIImageView!
    @IBOutlet weak var purplePokeballImageView: UIImageView!
    @IBOutlet weak var whitePokeballImageView: UIImageView!
    @IBOutlet weak var redPokeballImageView: UIImageView!
    @IBOutlet weak var yellowPokeballImageView: UIImageView!
    
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let keyManager = KeychainManager()
        
        do {
            let t = try keyManager.deleteToken(username: "carlosrecinos")
        } catch let error {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        setInitConfig()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        attempToLogin()
//        setLoggedToTrue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func inject(presenter: LoginPresenterProtocol) {
        loginPresenter = presenter
    }
    
    func setInitConfig() {
        setLoadingStatus(to: false)
        loginErrorLabel?.text = ""
        usernameInputText?.text = "carlosrecinos"
        passwordInputText?.text = "chalate"
        initPokeballImageViews()
        animateBackgroundImageView()
        animatePokeballsRotation()
    }
    
    func animatePokeballsRotation() {
        for pokeball in pokeballs {
            UIView.animate(withDuration: backgroundAnimation.duration, delay: 0, options: [.repeat, .autoreverse], animations: {
                pokeball.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(self.backgroundAnimation.rotation))
            })
        }
    }
    
    func animateBackgroundImageView() {
        let initialBackgroundXAxis = loginBackgroundImageView?.center.x
        if let initialBackgroundXAxis = initialBackgroundXAxis {
            UIView.animate(withDuration: backgroundAnimation.duration, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.loginBackgroundImageView.center.x = initialBackgroundXAxis - 100
            })
        }
    }
    
    func initPokeballImageViews() {
        let pokeballsImageViews = [
            bluePokeballImageView!,
            purplePokeballImageView!,
            redPokeballImageView!,
            whitePokeballImageView!,
            yellowPokeballImageView!
        ]
        for pokeball in pokeballsImageViews {
            let handler = PokeballAnimationHandler(initialPosition: pokeball.center.y, imageView: pokeball)
            pokeballs.append(handler)
        }
    }
    
    func attempToLogin() {
        setLabelStatus(hidden: true, message: nil)
        let username = usernameInputText?.text
        let password = passwordInputText?.text
        loginPresenter?.signIn(username, password)
    }
    
    func setLoggedToTrue() {
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "isLogged")
    }
    
    func goToMain() {
        DispatchQueue.main.async {
            print("Going to main")
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
    }
    
    func setLoadingStatus(to status: Bool) {
        loading = status
        animatePokeballs()
        setButtonEnabled(to: !status)
        setActivityIndicatorHidden(to: !status)
    }
    
    func setButtonEnabled(to status: Bool) {
        signInButton?.isEnabled = status
    }
    
    func setActivityIndicatorHidden(to status: Bool) {
        loadingActivityIndicator?.isHidden = status
    }
    
    func setLabelStatus(hidden: Bool, message: String?) {
        if(hidden) {
            loginErrorLabel?.text = ""
        } else {
            loginErrorLabel?.text = message
        }
    }
    
    func showErrorMessage(message: String) {
        setLoadingStatus(to: false)
        setLabelStatus(hidden: false, message: message)
        animateLabel()
    }
    
    func animatePokeballs() {
        var delayedTime = 0.0
        for pokeball in pokeballs {
            if loading {
                _ = Timer.scheduledTimer(withTimeInterval: delayedTime, repeats: false) { (timer) in
                    self.animatePokeball(pokeballImageView: pokeball.imageView)
                }
                delayedTime += 0.2
            } else {
                UIView.animate(
                    withDuration: pokeballsAnimation.duration * 2,
                    delay: 0,
                    usingSpringWithDamping: CGFloat(pokeballsAnimation.usingSpringWithDamping),
                    initialSpringVelocity: CGFloat(pokeballsAnimation.initialSpringVelocity),
                    options: [],
                    animations: {
                        pokeball.imageView?.center.y = pokeball.initialPosition
                    })
                _ = Timer.scheduledTimer(withTimeInterval: pokeballsAnimation.duration, repeats: false) { (timer) in
                    pokeball.imageView?.layer.removeAnimation(forKey: "position")
                }
            }
            
        }
        
    }
    
    func animatePokeball(pokeballImageView: UIImageView?) {
        let currentYAxis = pokeballImageView?.center.y
        if let currentYAxis = currentYAxis {
            let toYAxis = currentYAxis - 50
            if self.loading {
                UIView.animate(
                    withDuration: pokeballsAnimation.duration,
                    delay: 0,
                    usingSpringWithDamping: CGFloat(pokeballsAnimation.usingSpringWithDamping),
                    initialSpringVelocity: CGFloat(pokeballsAnimation.initialSpringVelocity),
                    options: [.repeat, .autoreverse],
                    animations: {
                        pokeballImageView?.center.y = toYAxis
                    })
            }
        }
    }
    
    func animateLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        if let viewToShake = loginErrorLabel {
            animation.duration = 0.03
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 5, y: viewToShake.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 5, y: viewToShake.center.y))
            
            viewToShake.layer.add(animation, forKey: "position")
        }
    }
}
