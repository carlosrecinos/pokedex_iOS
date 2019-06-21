import UIKit

protocol PokemonDetailViewControllerProtocol {
    func loadPokemonDetail(_ detail: PokemonDetail)
    func inject(presenter: PokemonDetailPresenterProtocol)
}

class PokemonDetailViewController: UIViewController, PokemonDetailViewControllerProtocol {

    var selectedPokemon: Pokemon?
    var spritesSegueIdentifier = "SpritesViewSegue"
    var statsSegueIdentifer = "StatsSegueIdentifier"
    var spritesCarouselViewController: SpritesCarouselViewController!
    var statsViewController: StatsViewController!
    var pokemonDetailPresenter: PokemonDetailPresenterProtocol?
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var contentScrollView: UIScrollView?
    @IBOutlet var typesStackView: UIStackView?
    @IBOutlet var typesContainer: UIView?
    @IBOutlet var statContainer: UIView?
    
    @IBOutlet var abilitiesContainer: UIView?
    @IBOutlet var abilitiesLabel: UILabel?
    
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
        self.navigationItem.leftBarButtonItem?.title = nil
        self.navigationItem.backBarButtonItem?.title = nil
        
        abilitiesContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        typesContainer?.layer.cornerRadius = 10
        typesContainer?.clipsToBounds = true
        
        abilitiesContainer?.layer.cornerRadius = 10
        abilitiesContainer?.clipsToBounds = true
        
        statContainer?.layer.cornerRadius = 10
        statContainer?.clipsToBounds = true
    }
    
    func loadPokemonInfo() {
        nameLabel?.text = selectedPokemon?.name
        requestDetail()
    }
    
    func requestDetail() {
        pokemonDetailPresenter?.getDetail(selectedPokemon?.getPokemonId() ?? 1)
    }
    
    func loadPokemonDetail(_ detail: PokemonDetail) {
        selectedPokemon?.detail = detail
        showDetailData()
    }
    
    func showDetailData() {
        loadSprites()
        loadTypes()
        loadStats()
        loadAbilities()
    }
    
    func loadStats() {
        if let stats = selectedPokemon?.detail?.stats {
            statsViewController?.loadStats(stats)
        }
        
    }
    
    func loadSprites() {
        let sprites = selectedPokemon?.detail?.sprites?.getSprites()
        if let sprites = sprites {
            spritesCarouselViewController?.loadSprites(sprites)
        }
    }
    
    func loadTypes() {
        if let types = selectedPokemon?.detail?.types {
            for type in types {
                let typeImageView = createTypeImageView(type.type.name)
                typeImageView.translatesAutoresizingMaskIntoConstraints = false
                typesStackView?.addArrangedSubview(typeImageView)
            }
        }
    }
    
    func loadAbilities() {
        let abilitiesText = selectedPokemon?.detail?.abilities.map({"\($0.ability.name)"}).joined(separator: "\n")
        abilitiesLabel?.text = abilitiesText
    }
    
    func createTypeImageView(_ type: String) -> UIImageView {
        let image = UIImageView()
        
        
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let imageUrl = "\(Constants.imagesBaseUrl)/\(type).png"
        image.imageFromURL(urlString: imageUrl, withSize: nil)
        
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SpritesCarouselViewController, segue.identifier == spritesSegueIdentifier {
            self.spritesCarouselViewController = destination
        } else if let destination = segue.destination as? StatsViewController, segue.identifier == statsSegueIdentifer {
            self.statsViewController = destination
        
            self.statsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
