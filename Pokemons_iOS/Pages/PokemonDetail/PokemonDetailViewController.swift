import UIKit

protocol PokemonDetailViewControllerProtocol {
    func loadPokemonDetail(_ detail: PokemonDetail)
    func inject(presenter: PokemonDetailPresenterProtocol)
}

class PokemonDetailViewController: UIViewController, PokemonDetailViewControllerProtocol {

    var selectedPokemon: PokemonModel?
    var pokemonStruct: Pokemon?
    var spritesSegueIdentifier = "SpritesViewSegue"
    var statsSegueIdentifer = "StatsSegueIdentifier"
    weak var spritesCarouselViewController: SpritesCarouselViewController!
    weak var statsViewController: StatsViewController!
    var pokemonDetailPresenter: PokemonDetailPresenterProtocol?
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var contentScrollView: UIScrollView?
    @IBOutlet weak var typesStackView: UIStackView?
    @IBOutlet weak var typesContainer: UIView?
    @IBOutlet weak var statContainer: UIView?
    
    @IBOutlet weak var abilitiesContainer: UIView?
    @IBOutlet weak var abilitiesLabel: UILabel?
    
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
        
        let catchPokemonButton = UIBarButtonItem(image: UIImage(named: "catch_icon")?.resizeImage(newWidth: 32), style: .plain, target: self, action: #selector(loadCatchPokemonView(_:)))
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItem?.title = nil
        self.navigationItem.rightBarButtonItem = catchPokemonButton
        
        abilitiesContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        typesContainer?.layer.cornerRadius = 10
        typesContainer?.clipsToBounds = true
        
        abilitiesContainer?.layer.cornerRadius = 10
        abilitiesContainer?.clipsToBounds = true
        
        statContainer?.layer.cornerRadius = 10
        statContainer?.clipsToBounds = true
    }
    
    @objc func loadCatchPokemonView(_ button: UIBarButtonItem) {
        performSegue(withIdentifier: "CatchPokemonSegue", sender: nil)
    }
    
    func loadPokemonInfo() {
        if let pokemon = selectedPokemon {
            pokemonStruct = pokemon.getStruct()
        }
        nameLabel?.text = selectedPokemon?.name
        requestDetail()
    }
    
    func requestDetail() {
        pokemonDetailPresenter?.getDetail(pokemonStruct?.getPokemonId() ?? 1)
    }
    
    func loadPokemonDetail(_ detail: PokemonDetail) {
        pokemonStruct?.detail = detail
        showDetailData()
    }
    
    func showDetailData() {
        loadSprites()
        loadTypes()
        loadStats()
        loadAbilities()
    }
    
    func loadStats() {
        if let stats = pokemonStruct?.detail?.stats {
            statsViewController?.loadStats(stats)
        }
        
    }
    
    func loadSprites() {
        let sprites = pokemonStruct?.detail?.sprites?.getSprites()
        if let sprites = sprites {
            spritesCarouselViewController?.loadSprites(sprites)
        }
    }
    
    func loadTypes() {
        if let types = pokemonStruct?.detail?.types {
            for type in types {
                let typeImageView = createTypeImageView(type.type.name)
                typeImageView.translatesAutoresizingMaskIntoConstraints = false
                typesStackView?.addArrangedSubview(typeImageView)
            }
        }
    }
    
    func loadAbilities() {
        let abilitiesText = pokemonStruct?.detail?.abilities.map({"\($0.ability.name)"}).joined(separator: "\n")
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
        } else if let destination = segue.destination as? CatchPokemonViewController, segue.identifier == "CatchPokemonSegue" {
            destination.pokemonToCatch = self.selectedPokemon
        }
    }
}
