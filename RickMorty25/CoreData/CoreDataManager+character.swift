//
//  CoreDataManager+character.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData
import UIKit

extension CoreDataManager {
    
//    func updateCharacter(_ character: CharacterEntity, with model: CharacterData) {
//        
//        character.url = model.url
//        character.entityId = Int64(model.id)
//        character.name = model.name
//        character.status = model.status
//        character.species = model.species
//        character.type = model.type
//        character.created = model.created
//        character.photo = model.photo
//        character.origin = model.origin
//        character.location = model.location
//        
//        if let episodes = model.episodes {
//            character.episode = NSSet(array: episodes)
//        }
//        do {
//            try context.save()
//        } catch {
//            print("Failed to update character: \(error)")
//        }
//    }
    
    func saveNewCharacter(with model: CharacterData) {
        
        let newCharacter = CharacterEntity(context: context)
        
        newCharacter.url = model.url
        newCharacter.entityId = Int64(model.id)
        newCharacter.name = model.name
        newCharacter.status = model.status
        newCharacter.species = model.species
        newCharacter.type = model.type
        newCharacter.created = model.created
        newCharacter.photo = model.photo
        newCharacter.origin = model.origin
        newCharacter.location = model.location
        
        if let episodes = model.episodes {
            newCharacter.episode = NSSet(array: episodes)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save new character: \(error)")
        }
    }
    
    func createOrUpdateCharacter(from model: CharacterData) {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "url == %@", model.url)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            
            if let existingCharacter = results.first {
                self.updateCharacter(existingCharacter, with: model)
            } else {
                self.saveNewCharacter(with: model)
            }
        } catch {
            print("Failed to fetch or save character: \(error)")
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
    
}
