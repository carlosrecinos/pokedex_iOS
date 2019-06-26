import Foundation
import UIKit
import CoreData

protocol PokemonListViewControllerProtocol {
    func updatePokemonsList(pokemons: NSFetchedResultsController<PokemonModel>, type: PokemonsListTypes)
}

enum PokemonsListTypes {
    case allPokemons
    case ownedPokemons
}

class PokemonListViewController: UIViewController, PokemonListViewControllerProtocol {
    
    @IBOutlet weak var isLoggedVarLabel: UILabel!
    @IBOutlet weak var allPokemonsCollectionView: UICollectionView!
    @IBOutlet weak var ownedPokemonsCollectionView: UICollectionView!
    weak var titleSegmentedControl: UISegmentedControl!
    
    var pokemonListPresenter: PokemonListPresenterProtocol?
    var ownedPokemons: [Pokemon] = []
    var allPokemons: NSFetchedResultsController<PokemonModel>?
    var isLoading = false
    var allPokemonsFooter: PokemonListFooterActivityIndicator?
    var ownedPokemonsFooter: PokemonListFooterActivityIndicator?
    var loadingFooterIdentifier = "PokemonListFooter"
    var footerSize: CGSize?
    
    var lastIndexPathForAllPokemons: [IndexPath]?
    var lastIndexPathForOwnedPokemons: [IndexPath]?
    
    func inject(presenter: PokemonListPresenterProtocol) {
        pokemonListPresenter = presenter
    }
    
    override func viewDidLoad() {
        setInitConfig()
        loadPokemonsData()
    }
    
    func setInitConfig() {
        configureNavigationBar()
        configureTabbar()
        configurePokemonsCollectionView()
    }
    
    func configureNavigationBar() {
        
        self.navigationItem.title = "Pokemons"
        self.navigationItem.titleView = buildSegmentedControlTitle()
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "filter_icon"), style: .done, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: nil)
    }
    
    func configureTabbar() {
        let tabBarItem = UITabBarItem(title: "Pokemons", image: UIImage(named: "pokeball_icon"), tag: 0)
        
        self.tabBarItem = tabBarItem
        self.tabBarController?.tabBar.tintColor = UIColor.pokeRed
        self.tabBarController?.tabBar.isTranslucent = false
        
    }
    
    func configurePokemonsCollectionView() {
        
        allPokemonsCollectionView.dataSource = self
        allPokemonsCollectionView.delegate = self
        
        allPokemonsCollectionView.register(UINib(nibName: "LoadingFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterIdentifier)
        
        allPokemonsCollectionView.register(PokemonCardCollectionViewCell.nib, forCellWithReuseIdentifier: PokemonCardCollectionViewCell.cellIdentifier)
        
        ownedPokemonsCollectionView.dataSource = self
        ownedPokemonsCollectionView.delegate = self
        
        ownedPokemonsCollectionView.register(UINib(nibName: "LoadingFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterIdentifier)
        
        ownedPokemonsCollectionView.register(PokemonCardCollectionViewCell.nib, forCellWithReuseIdentifier: PokemonCardCollectionViewCell.cellIdentifier)
        
        let spacing = CGFloat(10.0)
        let horizontalLayoutMargin = CGFloat(8.0)
        let width = (view.frame.size.width - spacing - CGFloat(horizontalLayoutMargin * 2)) / 2
        let allPokemonsLayout = allPokemonsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let ownedPokemonslayout = ownedPokemonsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        allPokemonsLayout.sectionInset = UIEdgeInsets(
            top: CGFloat(16),
            left: horizontalLayoutMargin,
            bottom: CGFloat(0),
            right: horizontalLayoutMargin)
        
        allPokemonsLayout.itemSize = CGSize(width: width, height: width * 1.2)
        footerSize = CGSize(width: view.frame.size.width, height: 55)
        allPokemonsLayout.footerReferenceSize = footerSize!
        
        ownedPokemonslayout.sectionInset = allPokemonsLayout.sectionInset
        ownedPokemonslayout.itemSize = allPokemonsLayout.itemSize
        ownedPokemonslayout.footerReferenceSize = footerSize!
        
        showAllPokemonsCollectionView()
        
    }
    
    func showAllPokemonsCollectionView() {
        allPokemonsCollectionView?.isHidden = false
        ownedPokemonsCollectionView?.isHidden = true
    }
    
    func showOwnedPokemonsCollectionView() {
        allPokemonsCollectionView?.isHidden = true
        ownedPokemonsCollectionView?.isHidden = false
    }
    
    func buildSegmentedControlTitle() -> UISegmentedControl {
        let items = ["All", "Owned"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 150, height: 35)
        segmentedControl.addTarget(self, action: #selector(onSegmentedPressedAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        let font = UIFont(name: "Pokemon Solid", size: 16)!
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        titleSegmentedControl = segmentedControl
        return segmentedControl
    }
    
    @objc func onSegmentedPressedAction(_ segmentedControl: UISegmentedControl) {

        if segmentedControl.selectedSegmentIndex == 1 {
            showOwnedPokemonsCollectionView()
            requestNewPokemonsList()
        } else {
            showAllPokemonsCollectionView()
        }
        
    }
    
    func loadPokemonsData() {
        pokemonListPresenter?.loadLocalPokemons()
    }
    
    func requestNewPokemonsList() {
        isLoading = true
        switch titleSegmentedControl.selectedSegmentIndex {
        case 0:
            pokemonListPresenter?.fetchPokemons(type: .allPokemons)
            showFooter(type: .allPokemons)
        case 1:
            pokemonListPresenter?.fetchPokemons(type: .ownedPokemons)
            showFooter(type: .ownedPokemons)
        default:
            print("Unhandled selection")
        }
        
    }
    
    func updatePokemonsList(pokemons: NSFetchedResultsController<PokemonModel>, type: PokemonsListTypes) {
        allPokemons = pokemons
        isLoading = false
        
    }

    func showFooter(type: PokemonsListTypes) {
        animateFooterActivityIndicator()
        updateCollectionViewLayoutFooterSize(size: footerSize!, type: type)
        
    }
    
    func animateFooterActivityIndicator() {
        switch titleSegmentedControl.selectedSegmentIndex {
        case 0:
            if let activityIndicator = allPokemonsFooter?.viewWithTag(5) as! UIActivityIndicatorView? {
                activityIndicator.startAnimating()
            }
        case 1:
            if let activityIndicator = ownedPokemonsFooter?.viewWithTag(5) as! UIActivityIndicatorView? {
                activityIndicator.startAnimating()
            }
        default:
            print("Unhandled")
        }
    }
    
    func updateCollectionViewLayoutFooterSize(size: CGSize, type: PokemonsListTypes) {
        switch type {
            
        case .allPokemons:
            let layout = allPokemonsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.footerReferenceSize = size
            
        case .ownedPokemons:
            let layout = ownedPokemonsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.footerReferenceSize = size
        }
    }
    
    func removeFooter(type: PokemonsListTypes) {
        let noVisibleFooter = CGSize(width: 1, height: 0.1)
        updateCollectionViewLayoutFooterSize(size: noVisibleFooter, type: type)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailViewController, let index = sender as? IndexPath {
            destination.hidesBottomBarWhenPushed = true
            let pokemon = allPokemons?.object(at: index)
            destination.selectedPokemon = pokemon
        }
    }
    
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch titleSegmentedControl.selectedSegmentIndex {
        case 0:
            return allPokemons?.fetchedObjects?.count ?? 0
        case 1:
            return ownedPokemons.count
        default:
            return 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeFooter(type: .allPokemons)
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
        
//        print("isLoading \(isLoading)")
        if (pullRatio >= 1) && !isLoading {
            requestNewPokemonsList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return buildCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch titleSegmentedControl.selectedSegmentIndex {
        case 0:
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterIdentifier, for: indexPath)
                self.allPokemonsFooter = footerView as? PokemonListFooterActivityIndicator
                return footerView
            }
        case 1:
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterIdentifier, for: indexPath)
                self.ownedPokemonsFooter = footerView as? PokemonListFooterActivityIndicator
                return footerView
            }
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func buildCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        //Prev implementation
//        var pokemonsList: [Pokemon]
//        switch titleSegmentedControl.selectedSegmentIndex {
//        case 0:
//            pokemonsList = allPokemons
//        case 1:
//            pokemonsList = ownedPokemons
//        default:
//            pokemonsList = []
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardCollectionViewCell.cellIdentifier, for: indexPath) as? PokemonCardCollectionViewCell

        let selectedPokemon = allPokemons?.object(at: indexPath)

        if let cell = cell, let selectedPokemon = selectedPokemon {
            cell.configure(selectedPokemon)
        } else {
            print("No cell")
        }
        return cell ?? UICollectionViewCell()
        
        
    }
    
}
