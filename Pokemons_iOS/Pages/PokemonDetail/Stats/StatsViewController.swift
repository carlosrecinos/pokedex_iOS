//
//  StatsViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/20/19.
//  Copyright © 2019 genui. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var statsTableView: UITableView!
    
    var stats: [PokemonStats]?
    var cellIdentifier = "StatCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statsTableView.separatorColor = UIColor.clear
        statsTableView?.delegate = self
        statsTableView?.dataSource = self
        statsTableView.register(StatCell.nib, forCellReuseIdentifier: StatCell.cellIdentifier)
        
        
    }
    
    func loadStats(_ stats: [PokemonStats]) {
        self.stats = stats
        statsTableView.reloadData()
    }
    
}

extension StatsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.cellIdentifier, for: indexPath) as? StatCell {
            if let stat = stats?[indexPath.row] {
                cell.configure(stat)
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
}
