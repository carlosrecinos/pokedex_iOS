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
    var footerView: PokemonListFooterActivityIndicator?
    var loadingFooterIdentifier = "PokemonListFooter"
    var footerSize: CGSize?
    
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
        
        let spacing = CGFloat(10.0)
        let horizontalLayoutMargin = CGFloat(8.0)
        let width = (view.frame.size.width - spacing - CGFloat(horizontalLayoutMargin * 2)) / 2
        let layout = pokemonListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        pokemonListCollectionView.register(UINib(nibName: "LoadingFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterIdentifier)
        
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
        segmentedControl.selectedSegmentIndex = 1
        
        let font = UIFont(name: "Pokemon Solid", size: 16)!
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        return segmentedControl
    }
    
    @objc func onSegmentedPressedAction(_ segmentedControl: UISegmentedControl) {
        print("something changed")
    }
    
    func requestNewPokemonsList() {
        isLoading = true
        pokemonListPresenter?.fetchPokemons()
        showFooter()
    }
    
    func updatePokemonsList(pokemons: [Pokemon]) {
        isLoading = false
        let initialArrayCount = pokemonsList.count
        pokemonsList += pokemons
//        let indexToAdd = pokemonsList.count == 0 ? 0 : pokemonsList.count - 1
//        let indexPath = IndexPath(row: indexToAdd, section: 0)
//        pokemonListCollectionView.insertItems(at: [indexPath])
        pokemonListCollectionView.reloadData()
    }

    func showFooter() {
        animateFooterActivityIndicator()
        
        updateCollectionViewLayoutFooterSize(size: footerSize!)
        
    }
    
    func animateFooterActivityIndicator() {
        print("before to")
    if let activityIndicator = footerView?.viewWithTag(5) as! UIActivityIndicatorView? {
        print("to animate")
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
            destination.selectedPokemon = pokemonsList[index.row]
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        pokemonListCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
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
            pokemonImageView.imageFromURL(urlString: imageUrl, withSize: CGSize(width: 100, height: 100))
        }
        if let pokemonNameLabel = cell.viewWithTag(2) as? UILabel {
            pokemonNameLabel.text = pokemonsList[indexPath.row].name
        }
        return cell
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
}
