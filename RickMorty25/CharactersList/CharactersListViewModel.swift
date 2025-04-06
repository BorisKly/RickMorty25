//
//  CharactersListViewModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

class CharactersListViewModel {
    
    var model = CharactersListModel()
    var characters: [CharacterData] = []

    var nextPageAvailiable = true
    var page = 1

    var reloadTableView: (() -> Void)?
    var onCharacterSelected: ((CharacterData) -> Void)?

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
                        charactersResponseData.results.forEach { character in
                            var originEntity: LocationEntity?
                            if let extractedId = character.origin.url.extractedId {
                                let entity = LocationEntity(context: CoreDataManager.shared.context)
                                entity.entityId = extractedId
                                entity.name = character.location.name
                                entity.url = character.location.url
                                originEntity = entity
                            }
                            var locationEntity: LocationEntity?
                            if let extractedId = character.location.url.extractedId {
                                let entity = LocationEntity(context: CoreDataManager.shared.context)
                                entity.entityId = extractedId
                                entity.name = character.location.name
                                entity.url = character.location.url
                                locationEntity = entity
                            }
                            var episodeEntities: [EpisodeEntity] = []
                            let episodes: [EpisodeEntity]? = nil
                            self.characters.append(
                                CharacterData(
                                    id: Int64(character.id),
                                    name: character.name,
                                    status: character.status,
                                    species: character.status,
                                    type: character.type,
                                    image: character.image,
                                    url: character.url,
                                    created: character.created,
                                    photo: nil,
                                    origin: originEntity,
                                    location: locationEntity,
                                    episodes: episodeEntities))
                        }
                        self.characters.forEach { CoreDataManager.shared.createOrUpdateCharacter(from: $0)
                        }
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
