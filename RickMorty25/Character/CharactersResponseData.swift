//
//  CharactersResponseData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct CharactersResponseData: Codable {
    let info: Info
    let results: [CharacterResponse]
}

struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}

struct CharacterResponse: Codable, Identifiable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}
