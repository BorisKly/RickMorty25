//
//  CoreDataManager+character.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData
import UIKit

extension CoreDataManager {
    
// MARK: -- add characters to DB
    
    func addCharacterToDB(character: CharacterData) {
        print(#function)
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "url == %@", character.url)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            if !results.isEmpty {
                print("Character \(character.url) already exists")
                // перевірити чи співпадає парам lastUpdatedDate чи щось типу такого... якщо різні - то update character 
                return
            }
            
            let newCharacterEntity = convertCharacterDataToCharacterEntity(character)
           
            if let origin = character.origin {
                newCharacterEntity.origin = findOrCreateLocationEntity(fromLocationData: origin)
            }
            
            if let location = character.location {
                newCharacterEntity.location = findOrCreateLocationEntity(fromLocationData: location)
                let newLocation = newCharacterEntity.location
                newLocation?.safelyAddToResidents(newCharacterEntity)
            }
            
            if let episode = character.episode {
                episode.forEach { episode in
                    let newEpisode = findOrCreateEpisodeEntiy(fromEpisodeData: episode)
                    newCharacterEntity.safelyAddToEpisode(newEpisode)
                }
            }
            saveContext()
        } catch {
            print("Failed to fetch or save character: \(error)")
        }
    }
    
    func convertCharacterDataToCharacterEntity(_ character: CharacterData) -> CharacterEntity {
        
        let entity = CharacterEntity(context: context)
        entity.entityId = character.id
        entity.name = character.name
        entity.status = character.status
        entity.species = character.species
        entity.type = character.type
        entity.image = character.image
        entity.url = character.url
        entity.created = character.created
        entity.photo = character.photo
        entity.origin = nil
        entity.location = nil
        entity.episode = []
        return entity
    }

// MARK: -- fetch characters from DB

    func fetchAllCharacters() -> [CharacterEntity] {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()

        do {
            let characters = try context.fetch(fetchRequest)
            return characters
        } catch {
            print("Failed to fetch all characters: \(error)")
            return []
        }
    }
    
    func fetchCharactersFromCoreData() -> [CharacterData] {
        print(#function)
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        do {
            let characterEntities = try context.fetch(fetchRequest)
            
            let characters: [CharacterData] = characterEntities.map { entity in
                CharacterData(
                    id: entity.entityId,
                    name: entity.name,
                    status: entity.status,
                    species: entity.species,
                    type: entity.type,
                    gender: entity.gender,
                    image: entity.image,
                    url: entity.url,
                    created: entity.created,
                    photo: entity.photo,
                    origin: entity.origin.map {
                        LocationData(id: $0.entityId, url: $0.url)
                    },
                    location: entity.location.map {
                        LocationData(id: $0.entityId, url: $0.url)
                    },
                    episode: (entity.episode as? Set<EpisodeEntity>)?.map { episodeEntity in
                        EpisodeData(
                            id: episodeEntity.entityId,
                            name: episodeEntity.name,
                            airDate: episodeEntity.airData,
                            episode: episodeEntity.episode,
                            characters: nil,
                            url: episodeEntity.url,
                            created: episodeEntity.created
                        )
                    }
                )
            }
            
            return characters
        } catch {
            print("Failed fetching from CoreData: \(error)")
            return []
        }
    }
}
