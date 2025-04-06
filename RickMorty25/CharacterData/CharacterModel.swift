//
//  CharacterModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import Foundation

struct CharacterModel {
    let id: Int64
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let image: String?
    let url: String
    let created: String?
    let photo: Data?
    let origin: LocationEntity?
    let location: LocationEntity?
    let episodes: [EpisodeEntity]?
}
