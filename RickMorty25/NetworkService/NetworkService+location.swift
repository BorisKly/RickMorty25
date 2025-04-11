//
//  NetworkService+location.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 11.04.2025.
//

import Foundation

extension NetworkService {
    func getAllLocations(completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .location)
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
    
    func getLocation(id: Int,
                     completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .location, pathSuffics: String(id))
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
}
