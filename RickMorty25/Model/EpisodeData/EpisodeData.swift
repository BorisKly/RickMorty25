//
//  EpisodeData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct EpisodeData {
    var id: Int64
    var name: String?
    var airDate, episode: String?
    var characters: [CharacterData]?
    var url: String
    var created: String?
}
