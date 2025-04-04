//
//  CharactersListViewModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

class CharactersListViewModel {
    
    var model = CharactersListModel()
    var characters: [CharacterResponse] = []


    var reloadTableView: (() -> Void)?

}
