import Foundation
import UIKit

protocol PokemonListViewControllerProtocol {
    func updatePokemonsList(pokemons: [Pokemon], type: PokemonsListTypes)
}

enum PokemonsListTypes {
    case allPokemons
    case ownedPokemons
}

class PokemonListViewController: UIViewController, PokemonListViewControllerProtocol {
    
    @IBOutlet weak var isLoggedVarLabel: UILabel!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    weak var titleSegmentedControl: UISegmentedControl!
    
    var pokemonListPresenter: PokemonListPresenterProtocol?
    var ownedPokemons: [Pokemon] = []
    var allPokemons: [Pokemon] = []
    var isLoading = false
    var footerView: PokemonListFooterActivityIndicator?
    var loadingFooterIdentifier = "PokemonListFooter"
    var footerSize: CGSize?
    
    var lastIndexPathForAllPokemons: [IndexPath]?
    var lastIndexPathForOwnedPokemons: [IndexPath]?
    
    func inject(presenter: PokemonListPresenterProtocol) {
        pokemonListPresenter = presenter
    }
    
    override func viewDidLoad() {
        setInitConfig()
        requestNewPokemonsList()
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor.pokeRed
        self.navigationController?.navigationBar.tintColor = UIColor.pokeYellow
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
        
        pokemonListCollectionView.dataSource = self
        pokemonListCollectionView.delegate = self
        
        pokemonListCollectionView.register(UINib(nibName: "LoadingFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterIdentifier)
        
        pokemonListCollectionView.register(PokemonCardCollectionViewCell.nib, forCellWithReuseIdentifier: PokemonCardCollectionViewCell.cellIdentifier)
        
        let spacing = CGFloat(10.0)
        let horizontalLayoutMargin = CGFloat(8.0)
        let width = (view.frame.size.width - spacing - CGFloat(horizontalLayoutMargin * 2)) / 2
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        layout.sectionInset = UIEdgeInsets(
            top: CGFloat(16),
            left: horizontalLayoutMargin,
            bottom: CGFloat(0),
            right: horizontalLayoutMargin)
        
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        footerSize = CGSize(width: view.frame.size.width, height: 55)
        layout.footerReferenceSize = footerSize!
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

        if(segmentedControl.selectedSegmentIndex == 1) {
            lastIndexPathForAllPokemons = pokemonListCollectionView.indexPathsForVisibleItems
            requestNewPokemonsList()
            
        } else {
            lastIndexPathForOwnedPokemons = pokemonListCollectionView.indexPathsForVisibleItems
            pokemonListCollectionView.reloadData()
            if let lastIndex = lastIndexPathForAllPokemons {
//                pokemonListCollectionView.reloadItems(at: lastIndex)
            }
        }
        
    }
    
    func requestNewPokemonsList() {
        isLoading = true
        switch titleSegmentedControl.selectedSegmentIndex {
        case 0:
            print("requesting all")
            pokemonListPresenter?.fetchPokemons(type: .allPokemons)
        case 1:
            print("requesting owned")
            pokemonListPresenter?.fetchPokemons(type: .ownedPokemons)
        default:
            print("Unhandled selection")
        }
        
        showFooter()
    }
    
    func updatePokemonsList(pokemons: [Pokemon], type: PokemonsListTypes) {
        isLoading = false
        
        switch type {
        case .allPokemons:
            allPokemons += pokemons
        case .ownedPokemons:
            ownedPokemons += pokemons
            if let lastIndex = lastIndexPathForOwnedPokemons {
//                pokemonListCollectionView.reloadItems(at: lastIndex)
            }
        }
        
        pokemonListCollectionView.reloadData()
        removeFooter()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailViewController, let index = sender as? IndexPath {
            let pokemon = pokemonsList()[index.row]
            destination.selectedPokemon = pokemon
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        pokemonListCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
    }
    
    func pokemonsList() -> [Pokemon] {
        if titleSegmentedControl.selectedSegmentIndex == 0 {
            return allPokemons
        }
        return ownedPokemons
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Showing \(pokemonsList().count) pokemons")
        return pokemonsList().count
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
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterIdentifier, for: indexPath)
            self.footerView = footerView as? PokemonListFooterActivityIndicator
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func buildCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let pokemonsList = self.pokemonsList()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardCollectionViewCell.cellIdentifier, for: indexPath) as? PokemonCardCollectionViewCell
        
        let selectedPokemon = pokemonsList[indexPath.row]
        
        if let cell = cell {
            cell.configure(selectedPokemon)
        } else {
            print("No cell")
        }
        return cell ?? UICollectionViewCell()
    }
    
}
