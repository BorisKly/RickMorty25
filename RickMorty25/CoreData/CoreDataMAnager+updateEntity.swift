//
//  CoreDataMAnager+updateEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
    func updateCharacter(_ character: CharacterEntity, with model: CharacterData, photo: Data) {
        character.entityId = Int64(model.id)
        character.name = model.name
        character.status = model.status
        character.species = model.species
        character.type = model.type
        character.created = model.created
        character.photo = photo
        character.origin = model.origin
        character.location = model.location

        if let episodes = model.episodes {
            character.episode = NSSet(array: episodes)
        }

        saveContext()
        print("Character updated or created successfully.")
    }
    
    func updateLocation(_ location: LocationEntity, with model: LocationData) {
        location.entityId = Int64(model.id)
        location.name = model.name
        location.type = model.type
        location.dimension = model.dimension
        location.created = model.created

        if let residents = model.residents {
            location.residents = NSSet(array: residents)
        }

        saveContext()
        print("Updated existing location with URL \(model.url)")
    }
    
    
}
