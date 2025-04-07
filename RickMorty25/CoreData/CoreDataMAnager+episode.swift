//
//  CoreDataMAnager+updateEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
    func fetchAllEpisodes() -> [EpisodeEntity] {
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()

        do {
            let episodes = try context.fetch(fetchRequest)
            return episodes
        } catch {
            print("Failed to fetch episodes: \(error)")
            return []
        }
    }
}
