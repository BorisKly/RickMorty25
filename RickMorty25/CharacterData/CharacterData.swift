//
//  CharacterModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import Foundation

struct CharacterData {
    let id: Int64
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let image: String?
    let url: String
    let created: String?
    var photo: Data?
    var origin: LocationEntity?
    var location: LocationEntity?
    var episodes: [EpisodeEntity]?
}
