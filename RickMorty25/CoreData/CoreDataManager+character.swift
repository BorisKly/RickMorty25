//
//  CoreDataManager+character.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData
import UIKit

extension CoreDataManager {
    
    func updateCharacter(_ entity: CharacterEntity, with model: CharacterData) {
        
        entity.entityId = model.id
        entity.name = model.name
        entity.status = model.status
        entity.species = model.species
        entity.type = model.type
        entity.image = model.image
        entity.url = model.url
        entity.created = model.created
        entity.photo = model.photo
        
        if let originData = model.origin {
            let originEntity = LocationEntity(context: context)
            originEntity.entityId = originData.id
            originEntity.name = originData.name
            originEntity.url = originData.url
            entity.origin = originEntity
        }

        if let locationData = model.location {
            let locationEntity = LocationEntity(context: context)
            locationEntity.entityId = locationData.id
            locationEntity.name = locationData.name
            locationEntity.url = locationData.url
            entity.location = locationEntity
        }

        if let episodeDataArray = model.episode {
            let episodeEntities = episodeDataArray.map { episodeData -> EpisodeEntity in
                let episodeEntity = EpisodeEntity(context: context)
                episodeEntity.name = episodeData.name
                episodeEntity.episode = episodeData.episode
                episodeEntity.airData = episodeData.airDate
                episodeEntity.url = episodeData.url
                return episodeEntity
            }
            entity.episode = NSSet(array: episodeEntities)
        }

        do {
            try context.save()
        } catch {
            print("Failed to update character: \(error)")
        }
    }

    func saveNewCharacter(with model: CharacterData) {
        let entity = CharacterEntity(context: context)
        updateCharacter(entity, with: model)
    }
    
    func createOrUpdateCharacter(from model: CharacterData) {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "url == %@", model.url)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            if !results.isEmpty {
                print("Character \(model.url) already exists")
                return
            }
            
            if let existingCharacter = results.first {
                self.updateCharacter(existingCharacter, with: model)
            } else {
                self.saveNewCharacter(with: model)
            }
        } catch {
            print("Failed to fetch or save character: \(error)")
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
    
}
