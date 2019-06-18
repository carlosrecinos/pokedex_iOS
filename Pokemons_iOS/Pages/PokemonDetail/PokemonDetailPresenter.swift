import Foundation

protocol PokemonDetailPresenterProtocol {
    var pokemonDetailViewController: PokemonDetailViewControllerProtocol? { get set }
    func getDetail(_ id: Int)
    func loadDetail(_ detail: PokemonDetail)
    
}

class PokemonDetailPresenter: PokemonDetailPresenterProtocol {
   
    var pokemonDetailViewController: PokemonDetailViewControllerProtocol?
    var detailInteractor: PokemonDetailInteractorProtocol?
    
    func inject(interactor: PokemonDetailInteractorProtocol) {
        detailInteractor = interactor
    }
    
    func getDetail(_ id: Int) {
        detailInteractor?.fetchPokemonDetail(id)
    }
    
    func loadDetail(_ detail: PokemonDetail) {
        pokemonDetailViewController?.loadPokemonDetail(detail)
    }
    
    
}
