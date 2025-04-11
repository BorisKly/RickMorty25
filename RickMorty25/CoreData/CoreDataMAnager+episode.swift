//
//  CoreDataMAnager+updateEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
    func findOrCreateEpisodeEntiy(fromEpisodeData episode: EpisodeData) -> EpisodeEntity {
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", episode.url)
        fetchRequest.fetchLimit = 1

        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }

        let newEpisode = EpisodeEntity(context: context)
        newEpisode.entityId = Int64(episode.id)
        newEpisode.name = episode.name
        newEpisode.url = episode.url
        return newEpisode
    }
    
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
