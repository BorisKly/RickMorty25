//
//  CharactersListViewModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

class CharactersListViewModel {
    
    var networkMonitor = NetworkMonitor()

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
        networkMonitor.$isConnected.sink { isConnected in
            if isConnected {
                self.fetchCharacters(page: self.page)
            } else {
                self.fetchCharactersFromCoreData()
            }
        }
        print(CoreDataManager.shared.fetchAllCharacters().count)
        print(CoreDataManager.shared.fetchAllLocations().count)
        print(CoreDataManager.shared.fetchAllEpisodes().count)
    }

    func numberOfItems() -> Int {
        characters.count
    }
    
    func fetchCharactersFromCoreData() {
        print(#function)
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
                            let characterData = self.characterResponseToCharacterData(character)
                            self.characters.append(
                                characterData)
                            print(characterData.name)
                            print(characterData.id)
                            print(characterData.url)
                        }
                        self.reloadTableView?()
                        if charactersResponseData.info.next == nil {
                            self.nextPageAvailiable = false
                        }
//                        self.characters.forEach { CoreDataManager.shared.createOrUpdateCharacter(from: $0)
//                        }
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
    
    func characterResponseToCharacterData(_ response: CharacterResponse) -> CharacterData {
        
        var result =  CharacterData(
            id: Int64(response.id),
            name: response.name,
            status: response.status,
            species: response.species,
            type: response.type,
            image: response.image,
            url: response.url,
            created: response.created,
            photo: nil,
            origin: nil,
            location: nil,
            episodes: nil
        )
        loadImage(from: response.image) { image in
            var updatedResponse = response
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                result.photo = imageData }
        }
        var originEntity = LocationEntity(context: CoreDataManager.shared.context)
        if let extractedId = response.origin.url.extractedId {
            let entity = LocationEntity(context: CoreDataManager.shared.context)
            entity.entityId = extractedId
            entity.name = response.location.name
            entity.url = response.location.url
            originEntity = entity
        }
        var locationEntity = LocationEntity(context: CoreDataManager.shared.context)
        if let extractedId = response.location.url.extractedId {
            let entity = LocationEntity(context: CoreDataManager.shared.context)
            entity.entityId = extractedId
            entity.name = response.location.name
            entity.url = response.location.url
            locationEntity = entity
        }
        result.origin = originEntity
        result.location = locationEntity
        
        return result
    }
}
