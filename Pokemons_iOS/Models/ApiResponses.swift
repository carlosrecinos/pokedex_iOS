import Foundation

struct PokemonsApiResponse: Decodable {
    let error: Bool
    let data: PokemonsPayload?
}

struct PokemonsPayload: Decodable {
    let count: Int?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

struct PokemonDetailApiResponse: Decodable {
    let error: Bool
    let data: PokemonDetail
}


struct LoginResponse: Decodable {
    let error: Bool
    let data: LoginPayload
}

struct LoginPayload: Decodable {
    let user: User
    let loginToken: String
}
