//
//  CharacterViewModel.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

class CharacterViewModel {

    var character: CharacterResponse
    var episode: EpisodeResponseData? {
        didSet {
            onEpisodeUpdated?(episode)
        }
    }
    var onEpisodeUpdated: ((EpisodeResponseData?) -> Void)?

    init(character: CharacterResponse) {
        self.character = character
        fetchEpisode(id: character.id)
    }

    func fetchEpisode(id: Int) {
        NetworkService.shared.getEpisode(id: id) { result in
            switch result {
            case .success(let result):
                let json = result.json
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let episodeResponseData = try JSONDecoder().decode(EpisodeResponseData.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.episode = episodeResponseData
                    }
                } catch {
                    print("Error decoding EpisodeResponseData: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
