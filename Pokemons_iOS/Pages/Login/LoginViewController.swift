//
//  LoginViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

let ANIMATION_DURATION = 0.5
let INITIAL_SPRING_VELOCITY = 10.0
let USING_SPRING_WITH_DAMPING = 10

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
//            let rotationAnimation = CABasicAnimation()
//            rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
//            rotationAnimation.isCumulative = true
//            rotationAnimation.autoreverses = true
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.toValue = 4 * Double.pi
//            rotationAnimation.duration = 10.0
//            pokeball.imageView?.layer.add(rotationAnimation, forKey: "transform.rotation")
            UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .autoreverse], animations: {
                pokeball.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(360))
            })
        }
    }
    
    func animateBackgroundImageView() {
        let initialBackgroundXAxis = loginBackgroundImageView?.center.x
        if let initialBackgroundXAxis = initialBackgroundXAxis {
            UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .autoreverse], animations: {
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
                    withDuration: ANIMATION_DURATION * 2,
                    delay: 0,
                    usingSpringWithDamping: CGFloat(USING_SPRING_WITH_DAMPING),
                    initialSpringVelocity: CGFloat(INITIAL_SPRING_VELOCITY),
                    options: [],
                    animations: {
                        pokeball.imageView?.center.y = pokeball.initialPosition
                    })
                _ = Timer.scheduledTimer(withTimeInterval: ANIMATION_DURATION, repeats: false) { (timer) in
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
                    withDuration: ANIMATION_DURATION,
                    delay: 0,
                    usingSpringWithDamping: CGFloat(USING_SPRING_WITH_DAMPING),
                    initialSpringVelocity: CGFloat(INITIAL_SPRING_VELOCITY),
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
