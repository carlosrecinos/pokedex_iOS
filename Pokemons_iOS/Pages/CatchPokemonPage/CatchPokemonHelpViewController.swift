//
//  CatchPokemonHelpViewController.swift
//  
//
//  Created by Carlos Recinos on 6/25/19.
//

import UIKit

class CatchPokemonHelpViewController: UIViewController {

    @IBOutlet var rulesContainer: UIView?
    @IBOutlet var rulesStackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRulesPage()
    }
    
    func configureRulesPage() {
        
        rulesContainer?.layer.cornerRadius = 20
        rulesContainer?.clipsToBounds = true
        
        for rule in CatchPokemonRules.rules {
            addRuleToStackView(rule)
        }
       
    }
    
    func addRuleToStackView(_ rule: String) {
        let ruleLabel = UILabel()
        let pokemonFont = UIFont(name: "Pokemon Solid", size: 17)
        ruleLabel.font = pokemonFont
        
        ruleLabel.textColor = UIColor.pokeYellow
        
        ruleLabel.layer.shadowColor = UIColor.pokeBlue.cgColor
        ruleLabel.layer.shadowRadius = 0
        ruleLabel.layer.shadowOpacity = 1.0
        ruleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        ruleLabel.layer.masksToBounds = false
        
        ruleLabel.numberOfLines = 0
        ruleLabel.lineBreakMode = .byWordWrapping
        ruleLabel.text = rule
        rulesStackView?.addArrangedSubview(ruleLabel)
    }
    
}
