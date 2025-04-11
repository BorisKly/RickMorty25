//
//  NetworkService+episode.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 11.04.2025.
//

import Foundation

extension NetworkService {
    
    func getAllEpisodes(completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .episode)
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
    
    func getEpisode(id: Int,
                    completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .episode, pathSuffics: String(id))
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
    
}
