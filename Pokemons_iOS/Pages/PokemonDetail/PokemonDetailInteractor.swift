import Foundation

protocol PokemonDetailInteractorProtocol {
    func fetchPokemonDetail(_ id: Int)
}

class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    var pokemonService: PokemonServiceProtocol?
    
    func fetchPokemonDetail(_ id: Int) {
        print("ready to fetch baby")
        pokemonService?.fetchPokemon(pokemonId: id)
        .onSuccess(callback: {<#T##([Pokemon]) -> Void#>})
    }
}
