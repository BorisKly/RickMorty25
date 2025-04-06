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

    var nextPageAvailiable = true
    var page = 1

    var reloadTableView: (() -> Void)?
    var onCharacterSelected: ((CharacterResponse) -> Void)?

    func didSelectCharacter(at index: Int) {
        let character = characters[index]
        onCharacterSelected?(character)
    }

    init() {
        fetchCharacters(page: page)
    }

    func numberOfItems() -> Int {
        characters.count
    }

    func fetchCharacters(page: Int) {
            NetworkService.shared.getCharacters(page: page) { result in
                switch result {
                case .success(let result):
                    let json = result.json
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let charactersResponseData = try JSONDecoder().decode(CharactersResponseData.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.characters.append(contentsOf: charactersResponseData.results)
//                            self.characters.forEach { CoreDataManager.shared.addCharacter(character: $0)
//                            }
                            self.reloadTableView?()
                            if charactersResponseData.info.next == nil {
                                self.nextPageAvailiable = false
                            }
                        }
                    } catch {
                        print("Error decoding CharactersResponseData: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
        }
    }

    func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.nextPageAvailiable {
                self.page += 1
                self.fetchCharacters(page: self.page)
            }
        }
    }
}
