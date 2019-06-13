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
    var isLoading = false
    var footerView: CustomFooterView?
    var loadingFooterIdentifier = "LoadingFooter"
    var footerSize: CGSize?
    
    func inject(presenter: PokemonListPresenterProtocol) {
        pokemonListPresenter = presenter
    }
    
    override func viewDidLoad() {
        setInitConfig()
        requestNewPokemonsList()
    }
    
    func setInitConfig() {
        pokemonListCollectionView.dataSource = self
        pokemonListCollectionView.delegate = self
        pokemonListCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterIdentifier)
        
        let spacing = CGFloat(20.0)
        let horizontalLayoutMargin = CGFloat(8.0)
        let width = (view.frame.size.width - spacing - CGFloat(horizontalLayoutMargin * 2)) / 3
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        layout.sectionInset = UIEdgeInsets(
            top: CGFloat(0),
            left: horizontalLayoutMargin,
            bottom: CGFloat(0),
            right: horizontalLayoutMargin)
        
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        footerSize = CGSize(width: view.frame.size.width, height: 55)
        layout.footerReferenceSize = footerSize!
        
    }
    
    func requestNewPokemonsList() {
        isLoading = true
        pokemonListPresenter?.fetchPokemons()
        showFooter()
    }
    
    func updatePokemonsList(pokemons: [Pokemon]) {
        isLoading = false
        pokemonsList += pokemons
        pokemonListCollectionView.reloadData()
    }

    func showFooter() {
        animateFooterActivityIndicator()
        updateCollectionViewLayoutFooterSize(size: footerSize!)
        
    }
    
    func animateFooterActivityIndicator() {
        if let activityIndicator = footerView?.viewWithTag(5) as! UIActivityIndicatorView? {
            activityIndicator.startAnimating()
        }
    }
    
    func updateCollectionViewLayoutFooterSize(size: CGSize) {
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.footerReferenceSize = size
    }
    
    func removeFooter() {
        let noVisibleFooter = CGSize(width: 1, height: 0.1)
        updateCollectionViewLayoutFooterSize(size: noVisibleFooter)
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsList.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeFooter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        
        if (pullRatio >= 1) && !isLoading {
            requestNewPokemonsList()
        }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterIdentifier, for: indexPath)
            self.footerView = footerView as? CustomFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}
