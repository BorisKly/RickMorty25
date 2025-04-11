//
//  NetworkService+character.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 11.04.2025.
//

import Foundation

extension NetworkService {
    
    func getAllCharacters(completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .character)
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
    
    func getCharacter(id: Int,
                       completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .character, pathSuffics: String(id))
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
    
    func getCharacters(page: Int,
                       completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .character, queryParams: ["page": "\(page)"])
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
}
