//
//  CoreDataManager+saveNewEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
    func saveNewCharacter(_ model: CharacterData, photo: Data) {
        let character = CharacterEntity(context: context)
        character.url = model.url
        updateCharacter(character, with: model, photo: photo)
        print("Created new character with URL \(model.url)")
    }
    
    func saveNewLocation(_ model: LocationData) {
        let location = LocationEntity(context: context)
        location.url = model.url
        updateLocation(location, with: model)
        print("Created new location with URL \(model.url)")
    }
    
}
