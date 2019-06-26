//
//  CatchPokemonHelpViewController.swift
//  
//
//  Created by Carlos Recinos on 6/25/19.
//

import UIKit

class CatchPokemonHelpViewController: UIViewController {

    @IBOutlet var rulesLabel: UILabel?
    @IBOutlet var rulesContainer: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRulesPage()
    }
    
    func configureRulesPage() {
        
        rulesContainer?.layer.cornerRadius = 20
        rulesContainer?.clipsToBounds = true
        
        rulesLabel?.lineBreakMode = .byWordWrapping
        rulesLabel?.numberOfLines = 0
        rulesLabel?.text = CatchPokemonRules.rules.map({ $0 }).joined(separator: "\n")
       
    }
    
}
