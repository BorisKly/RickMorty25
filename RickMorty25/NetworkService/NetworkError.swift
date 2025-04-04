//
//  NetworkApiErrors.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case requestError(String)
    case unknownError
    case invalidTask
}
