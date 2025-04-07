//
//  EpisodeData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct EpisodeData {
    let id: Int64
    let name, airDate, episode: String?
    let characters: [CharacterData]?
    let url: String
    let created: String?
}
