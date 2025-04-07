//
//  LocationData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct LocationData {
    var id: Int
    var name, type, dimension: String?
    var residents: [CharacterEntity]?
    var url: String
    var created: String?
}
