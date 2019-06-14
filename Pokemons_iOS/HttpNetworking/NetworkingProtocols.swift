//
//  NetworkingProtocols.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures

enum NetworkingError: Error {
    case serviceError
    case authError
}

struct HttpResponse {
    let request: URLRequest?
    let response: HTTPURLResponse?
    let data: Data?
}

protocol HttpNetworking {
    func request(url: String, httpHeaders: [String:String]) -> Future<HttpResponse, NetworkingError>
    func request(url: String) -> Future<HttpResponse, NetworkingError>
    
    func post(url: String, httpHeaders: [String: String]?, parameters: [String: Any]) -> Future<HttpResponse, NetworkingError>
}
