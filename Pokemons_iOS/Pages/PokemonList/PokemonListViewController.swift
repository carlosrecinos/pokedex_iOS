//
//  PokemonListViewController.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import UIKit

protocol PokemonListViewControllerProtocol {
    func updatePokemonsList(pokemons: [Pokemon])
}

class PokemonListViewController: UIViewController, PokemonListViewControllerProtocol {
    
    
    @IBOutlet weak var isLoggedVarLabel: UILabel!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    var pokemonListPresenter: PokemonListPresenterProtocol?
    var pokemonsList: [Pokemon] = []
    var isLoading: Bool = false
    var footerView: CustomFooterView?
    let footerViewReuseIdentifier = "RefreshFooterView"
    
    func inject(presenter: PokemonListPresenterProtocol) {
        pokemonListPresenter = presenter
    }
    
    override func viewDidLoad() {
        setInitConfig()
        requestNewPokemonsList()
    }
    
    func requestNewPokemonsList() {
        pokemonListPresenter?.fetchPokemons()
    }
    
    func setInitConfig() {
        pokemonListCollectionView.dataSource = self
        pokemonListCollectionView.delegate = self
        let spacing = CGFloat(20.0)
        let horizontalLayoutMargin = CGFloat(8.0)
        let width = (view.frame.size.width - spacing - CGFloat(horizontalLayoutMargin * 2)) / 3
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        pokemonListCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        layout.sectionInset = UIEdgeInsets(
            top: CGFloat(0),
            left: horizontalLayoutMargin,
            bottom: CGFloat(0),
            right: horizontalLayoutMargin)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
    }
    
    func updatePokemonsList(pokemons: [Pokemon]) {
        pokemonsList += pokemons
        pokemonListCollectionView.reloadData()
        self.isLoading = true
    }
    
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCell", for: indexPath)
        if let cellViewContaienr = cell.viewWithTag(0) {
            cellViewContaienr.layer.cornerRadius = 20.0
            cellViewContaienr.layer.shadowColor = UIColor.gray.cgColor
            cellViewContaienr.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cellViewContaienr.layer.shadowRadius = 12.0
            cellViewContaienr.layer.shadowOpacity = 0.7
        }
        if let pokemonImageView = cell.viewWithTag(1) as? UIImageView {
            let imageUrl = pokemonsList[indexPath.row].getImageUrl()
            pokemonImageView.imageFromURL(urlString: imageUrl)
        }
        if let pokemonNameLabel = cell.viewWithTag(2) as? UILabel {
            pokemonNameLabel.text = pokemonsList[indexPath.row].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemonsList[indexPath.row]
        print("pokemon selected: \(selectedPokemon.name)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            requestNewPokemonsList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                self.isLoading = true
                self.footerView?.startAnimate()
                self.requestNewPokemonsList()
            }
        }
    }
    
}
