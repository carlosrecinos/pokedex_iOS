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
    @IBOutlet var typesStackView: UIStackView?
    
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
//                typesStackView?.addSubview(typeImageView)
                
                typesStackView?.addArrangedSubview(typeImageView)
            }
        }
    }
    
    func createTypeImageView(_ type: String) -> UIImageView {
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: 0, width: 80, height: 93.75)
        image.bounds = image.frame.insetBy(dx: 20, dy: 20.0)
        image.heightAnchor.constraint(equalToConstant: 93.75).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        let imageUrl = "\(Constants.baseUrl)/images/\(type).png"
        image.imageFromURL(urlString: imageUrl, withSize: nil)
        
        return image
    }
    
    func loadStats() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SpritesCarouselViewController, segue.identifier == spritesSegueIdentifier {
            self.spritesCarouselViewController = destination
        }
    }
}
