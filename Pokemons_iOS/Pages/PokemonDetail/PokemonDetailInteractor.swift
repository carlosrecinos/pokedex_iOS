import Foundation

protocol PokemonDetailInteractorProtocol {
    func fetchPokemonDetail(_ id: Int)
    func inject(_ pokemonService: PokemonServiceProtocol)
}

class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    
    var pokemonDetailPresenter: PokemonDetailPresenterProtocol?
    var pokemonService: PokemonServiceProtocol?
    
    func inject(_ pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
    
    func fetchPokemonDetail(_ id: Int) {
        pokemonService?.fetchPokemon(id)
        .onSuccess(callback: { detail in
            self.pokemonDetailPresenter?.loadDetail(detail)
        })
        .onFailure(callback: { error in
            print(error)
        })
    }
}
