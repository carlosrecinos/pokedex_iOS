import UIKit

protocol PokemonDetailViewControllerProtocol {
    func loadPokemonDetail(_ detail: PokemonDetail)
    func inject(presenter: PokemonDetailPresenterProtocol)
}

class PokemonDetailViewController: UIViewController, PokemonDetailViewControllerProtocol {

    var selectedPokemon: Pokemon?
    var spritesSegueIdentifier = "SpritesViewSegue"
    var spritesCarouselViewController: SpritesCarouselViewController!
    var pokemonDetailPresenter: PokemonDetailPresenterProtocol?
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var contentScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        loadPokemonInfo()
    }
    
    func inject(presenter: PokemonDetailPresenterProtocol) {
        pokemonDetailPresenter = presenter
    }
    
    func initConfig() {
        navigationController?.view.backgroundColor = UIColor.groupTableViewBackground
        self.navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem(title: "< Pokemons", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        if let pokemonFont = UIFont(name: "Pokemon Solid", size: 20) {
            print("new font")
            backButton.setTitleTextAttributes([NSAttributedString.Key.font: pokemonFont], for: UIControl.State.normal)
            
        }
        
        self.navigationItem.leftBarButtonItem?.title = nil
        self.navigationItem.backBarButtonItem?.title = nil
        
    }
    
    func loadPokemonInfo() {
        nameLabel?.text = selectedPokemon?.name
        requestDetail()
        print("pokemon info loading...")
    }
    
    func requestDetail() {
        pokemonDetailPresenter?.getDetail(selectedPokemon?.getPokemonId() ?? 1)
    }
    
    func loadPokemonDetail(_ detail: PokemonDetail) {
        print("view has the data!!!")
        selectedPokemon?.detail = detail
        showDetailData()
    }
    
    func showDetailData() {
        
        loadSprites()
    }
    
    func loadSprites() {
        let sprites = getSprites()
        spritesCarouselViewController?.loadSprites(sprites)
    }
    
    func getSprites() -> [String: String] {
        var dictionary: [String: String] = [:]
        do {
            let temporalDictionary = try selectedPokemon?.detail?.sprites?.allProperties()
            if let temporalDictionary = temporalDictionary {
                for (key, value) in temporalDictionary {
                    dictionary[key] = value as? String
                }
            }
        } catch let error {
            print("Error getting sprites", error)
        }
        print("dics", dictionary)
        return dictionary
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SpritesCarouselViewController, segue.identifier == spritesSegueIdentifier {
            self.spritesCarouselViewController = destination
        }
    }
}
