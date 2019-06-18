import UIKit

protocol PokemonDetailViewControllerProtocol {
    func loadInfo()
}

class PokemonDetailViewController: UIViewController {

    var selectedPokemon: Pokemon?
    var spritesSegueIdentifier = "SpritesViewSegue"
    var spritesCarouselViewController: SpritesCarouselViewController!
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var contentScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
        loadPokemonInfo()
        // Do any additional setup after loading the view.
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
        nameLabel?.text = "selectedPokemon?.name"
        loadSprites()
        print("pokemon info loaded")
    }
    
    func loadSprites() {
        let sprites = [
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png",
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/30.png",
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/40.png",
        ]
        spritesCarouselViewController?.loadSprites(sprites)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SpritesCarouselViewController, segue.identifier == spritesSegueIdentifier {
            self.spritesCarouselViewController = destination
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
