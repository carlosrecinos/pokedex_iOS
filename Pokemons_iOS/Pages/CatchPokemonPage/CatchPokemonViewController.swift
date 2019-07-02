import UIKit
import AVFoundation

class CatchPokemonViewController: UIViewController {

    var pokemonToCatch: PokemonModel?
    var pokemonStruct: Pokemon?
    var pokemonBattleStruct: PokemonBattle?
    var pokemonBattle: PokemonBattleModel?
    var coreDataManager: CoreDataManager?
    var audioPlayer = AVAudioPlayer()
    
    var currentGoal: Int = 0
    
    @IBOutlet weak var pokeballSlider: StatsPokemonSlider?
    @IBOutlet weak var infoContainer: UIView?
    @IBOutlet weak var gameOverContainer: UIView?
    
    @IBOutlet weak var goalLabel: UILabel?
    @IBOutlet weak var currentScoreLabel: UILabel?
    @IBOutlet weak var roundLabel: UILabel?
    
    @IBOutlet weak var pokemonImage: UIImageView?
    @IBOutlet weak var shadowImage: UIImageView?
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonStruct = pokemonToCatch?.getStruct()
        configureBattleArena()
    }
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        saveRound()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        flipContainer(from: gameOverContainer, to: infoContainer, effect: .transitionFlipFromRight)
    }
    
    
    @objc func showCatchPokemonInfo(_ button: UIBarButtonItem) {
        performSegue(withIdentifier: "CatchPokemonHelpSegue", sender: nil)
    }
    
    func inject(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func configureBattleArena() {
        configureLayout()
        playBackgroundMusic()
        initBattle()
    }
    
    func playBackgroundMusic() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ukelele_sound", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.setVolume(1, fadeDuration: 10)
        } catch let error {
            print(error)
        }
    }
    
    func configureLayout() {
        
        gameOverContainer?.isHidden = true
        
        let infoButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(showCatchPokemonInfo(_:)))
        
        navigationItem.rightBarButtonItem = infoButton
        
        if let pokemonImageUrl = pokemonStruct?.getImageUrl() {
            let size = CGSize(width: 200, height: 200)
            pokemonImage?.imageFromURL(urlString: pokemonImageUrl, withSize: size)
            shadowImage?.image = UIImage(named: "spot_shadow")
            shadowImage?.contentMode = .scaleAspectFill
        }
        
        infoContainer?.layer.cornerRadius = 20
        infoContainer?.clipsToBounds = true
        
        gameOverContainer?.layer.cornerRadius = 20
        gameOverContainer?.clipsToBounds = true
        
        goButton?.layer.cornerRadius = 8
        goButton?.clipsToBounds = true
        
        configureSlider()
    }
    
    func configureSlider() {
        pokeballSlider?.minimumTrackTintColor = UIColor.pokeYellow
        pokeballSlider?.maximumTrackTintColor = UIColor.pokeYellowDarker
        
        pokeballSlider?.minimumValue = 0
        pokeballSlider?.maximumValue = 100
        
        let thumbImage = UIImage(named: "pokeballs_red")?.resizeImage(newWidth: 32)
        pokeballSlider?.setThumbImage(thumbImage, for: .normal)
    }
    
    func initBattle() {
        if let battle = pokemonBattle {
            loadPrevBattle(battle)
        } else {
            loadNewBattle()
        }
    }
    
    func loadPrevBattle(_ battle: PokemonBattleModel) {
        
    }
    
    func loadNewBattle() {
        pokemonBattleStruct = PokemonBattle(dateStarted: Date(), score: 0, round: 1)
        
        setLabelValues()
        resetSlider()
        
    }
    
    func saveRound() {
        if pokemonBattleStruct?.round == 3 {
            finishGame()
        } else {
            pokemonBattleStruct?.round += 1
        }
        pokemonBattleStruct?.score += calculateObtainedScore()
        setLabelValues()
       
    }
    
    func setLabelValues() {
        if let battleStruct = pokemonBattleStruct {
            currentGoal = getRandomNumber()
            
            roundLabel?.text = String(battleStruct.round)
            currentScoreLabel?.text = String(battleStruct.score)
            goalLabel?.text = String(currentGoal)
        }
    }
    
    func calculateObtainedScore() -> Int {
        let value = Int(pokeballSlider?.value ?? 0)
        let difference = calculateDifference(value)
        var scoreObtained = 50 - difference
        if scoreObtained < 0 {
            scoreObtained = 0
        }
        return scoreObtained
    }
    
    func calculateDifference(_ value: Int) -> Int {
        let difference: Int
        if value > currentGoal {
            difference = value - currentGoal
        } else if value < currentGoal {
            difference = currentGoal - value
        } else {
            difference = 0
        }
        return difference
    }
    
    func finishGame() {
        goButton?.isEnabled = false
        flipContainer(from: infoContainer, to: gameOverContainer, effect: .transitionFlipFromLeft)
        showResult()
    }
    
    func flipContainer(from: UIView?, to: UIView?, effect: UIView.AnimationOptions) {
        if let fromView = from, let toView = to {
//            fromView.isHidden = false
            let transitionOptions: UIView.AnimationOptions = [effect, .showHideTransitionViews]
            
            UIView.transition(with: fromView, duration: 0.3, options: transitionOptions, animations: {
                
            })
            
            UIView.transition(with: toView, duration: 0.3, options: transitionOptions, animations: {
                toView.isHidden = false
            })
            
            
        }
    }
    
    func showResult() {
        
    }
    
    func resetSlider() {
        pokeballSlider?.value = Float(getRandomNumber()).rounded()
    }
    
    func getRandomNumber() -> Int {
        return Int.random(in: 0...100)
    }
    
}
