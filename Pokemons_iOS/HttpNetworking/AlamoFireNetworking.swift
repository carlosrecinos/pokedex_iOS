//
//  AlamoFireNetworking.swift
//  Pokemons_iOS
//
//  Created by Carlos Recinos on 6/7/19.
//  Copyright © 2019 genui. All rights reserved.
//

import Foundation
import BrightFutures
import Alamofire

class AlamofireNetworking: HttpNetworking {
    
    func request(url: String, httpHeaders: [String : String]) -> Future<HttpResponse, NetworkingError> {
        let promise = Promise<HttpResponse, NetworkingError>()
        Alamofire.request(url, headers: httpHeaders).responseJSON { dataRequest in
            if let responseData = dataRequest.data {
                let httpResponse = HttpResponse(request: dataRequest.request, response: dataRequest.response, data: responseData)
                promise.success(httpResponse)
            } else {
                promise.failure(.serviceError)
            }
        }
        return promise.future
    }
    
    func request(url: String) -> Future<HttpResponse, NetworkingError> {
        let promise = Promise<HttpResponse, NetworkingError>()
        Alamofire.request(url).responseJSON { dataRequest in
            if let responseData = dataRequest.data {
                let httpResponse = HttpResponse(request: dataRequest.request, response: dataRequest.response, data: responseData)
                promise.success(httpResponse)
            } else {
                promise.failure(.serviceError)
            }
        }
        return promise.future
    }
    
    func post(url: String, httpHeaders: [String : String]?, parameters: [String : Any]) -> Future<HttpResponse, NetworkingError> {
        let promise = Promise<HttpResponse, NetworkingError>()
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { dataRequest in
            if let responseData = dataRequest.data {
                let httpResponse = HttpResponse(request: dataRequest.request, response: dataRequest.response, data: responseData)
                promise.success(httpResponse)
            } else {
                promise.failure(.serviceError)
            }
        }
        return promise.future
    }
}
