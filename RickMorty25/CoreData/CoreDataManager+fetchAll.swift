//
//  CoreDataManager+fetchAll.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    func fetchAllLocations() -> [LocationEntity] {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()

        do {
            let locations = try context.fetch(fetchRequest)
            return locations
        } catch {
            print("Failed to fetch locations: \(error)")
            return []
        }
    }

    func fetchAllCharacters() -> [CharacterEntity] {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()

        do {
            let characters = try context.fetch(fetchRequest)
            return characters
        } catch {
            print("Failed to fetch characters: \(error)")
            return []
        }
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
