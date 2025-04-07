//
//  LocationData.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct LocationData {
    var id: Int64
    var name, type, dimension: String?
    var residents: [CharacterData]?
    var url: String
    var created: String?
}
