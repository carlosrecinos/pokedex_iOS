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
        print("ready to fetch baby")
        pokemonService?.fetchPokemon(id)
        .onSuccess(callback: { detail in
            print("success fetch detail wuuuu")
            self.pokemonDetailPresenter?.loadDetail(detail)
        })
        .onFailure(callback: { error in
            print(error)
        })
    }
}
