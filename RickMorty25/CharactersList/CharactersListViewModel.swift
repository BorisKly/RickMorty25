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

    init() {
        fetchCharacters(page: page)
    }

    func fetchCharacters(page: Int) {
        print(#function)
        let data = createRequestData(page: page)

            NetworkService.shared.getCharacters(data: data, settings: nil) { result in
                switch result {
                case .success(let result):
                    let json = result.json
                    print(json)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        print(json)
                        let charactersResponseData = try JSONDecoder().decode(CharactersResponseData.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.characters.append(contentsOf: charactersResponseData.results)
                            self.reloadTableView?()
                            if charactersResponseData.info.next == nil {
                                self.nextPageAvailiable = false
                            }
                        }
                    } catch {
                        print("Error decoding UsersResponseData: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
        }
    }

    private func createRequestData(page: Int) -> [String: Any] {
        let data: [String: Any] = [
            "queryParams": [
                "page": String(page)
//                "count": String(model.numberOfUsersPerPage)
            ]
        ]
        return data
    }
}
