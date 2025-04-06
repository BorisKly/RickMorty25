//
//  LocationData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct LocationData {
    let id: Int
    let name, type, dimension: String
    let residents: [CharacterEntity]?
    let url: String
    let created: String
}
