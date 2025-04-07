//
//  CoreDataManager+saveNewEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
    func saveNewLocation(_ model: LocationData) {
        let location = LocationEntity(context: context)
        location.url = model.url
        updateLocation(location, with: model)
        print("Created new location with URL \(model.url)")
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
    
    func locationDataToLocationEntity(_ data: LocationData) -> LocationEntity {
        let entity = LocationEntity(context: context)
        
        entity.entityId = Int64(data.id)
        entity.name = data.name
        entity.type = data.type
        entity.dimension = data.dimension
        entity.url = data.url
        entity.created = data.created
        
        if let residents = data.residents {
            entity.residents = NSSet(array: residents)
        }
        
        return entity
    }
    
    func saveLocationToCoreData(from model: LocationData) {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", model.url)
        
        do {
            let results = try self.context.fetch(fetchRequest)

            let location: LocationEntity
            if let existingLocation = results.first {
                location = existingLocation
                print("Updating existing location with id \(model.url)")
            } else {
                location = LocationEntity(context: self.context)
                location.url = model.url
                print("Creating new location with id \(model.url)")
            }

            location.entityId = Int64(model.id)
            location.name = model.name
            location.type = model.type
            location.dimension = model.dimension
            location.created = model.created

            if let residents = model.residents {
                location.residents = NSSet(array: residents)
            }
            self.saveContext()
            print("Location saved successfully.")
        } catch {
            print("Failed to fetch or save location: \(error)")
        }
        
    }
}
