//
//  CharactersListViewModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

class CharactersListViewModel {
    
    private var networkMonitor: NetworkMonitor
    
    var isConnected: Bool {
        return networkMonitor.isConnected
    }
    
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
        self.networkMonitor = NetworkMonitor.shared
        
        if isConnected {
            self.fetchCharacters(page: self.page)
        } else {
            let fetchedCharacters = CoreDataManager.shared.fetchCharactersFromCoreData()
            self.characters = fetchedCharacters
        }
        
        print(CoreDataManager.shared.fetchAllCharacters().count)
        print(CoreDataManager.shared.fetchAllLocations().count)
        print(CoreDataManager.shared.fetchAllEpisodes().count)
    }
    
    deinit {
        networkMonitor.stopMonitoring()
    }
    
    func numberOfItems() -> Int {
        characters.count
    }

    func fetchCharacters(page: Int) {
        print(#function)
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
                        }
                        self.reloadTableView?()
                        if charactersResponseData.info.next == nil {
                            self.nextPageAvailiable = false
                        }
                        self.characters.forEach { character in
                             CoreDataManager.shared.createOrUpdateCharacter(from: character)
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
    
    func characterResponseToCharacterData(_ response: CharacterResponse) -> CharacterData {
        
        var result =  CharacterData(
            id: Int64(response.id),
            name: response.name,
            status: response.status,
            species: response.species,
            type: response.type,
            gender: response.gender,
            image: response.image,
            url: response.url,
            created: response.created,
            photo: nil,
            origin: nil,
            location: nil,
            episode: nil
        )
        loadImage(from: response.image) { image in
            var updatedResponse = response
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                result.photo = imageData }
        }
        
        if let originLocationid = response.origin.url.extractedId {
            let originLocation = LocationData(
                id: originLocationid,
                url: response.origin.url)
            result.origin = originLocation
        }
        if let currentLocationid = response.location.url.extractedId {
            let currentLocation = LocationData(
                id: currentLocationid,
                name: response.name,
                url: response.location.url)
            result.location = currentLocation
        }
        return result
    }
}
