//
//  CoreDataManager+saveNewEntity.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import CoreData

extension CoreDataManager {
    
// MARK: -- add location to DB

//    func addLocationToDB(location: LocationData) {
//        
//        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
//        
//        fetchRequest.predicate = NSPredicate(format: "url == %@", location.url)
//        
//        do {
//            let results = try self.context.fetch(fetchRequest)
//            if !results.isEmpty {
//                print("Location \(location.url) already exists")
//                // перевірити чи співпадає парам lastUpdatedDate чи щось типу такого... якщо різні - то update location 
//                return
//            }
//            
//            let newLocationEntity = convertCharacterDataToCharacterEntity(character)
//           
//            if let origin = location.origin {
//                newCharacterEntity.origin = findOrCreateLocationEntity(fromLocationData: origin)
//            }
//            
//            if let location = character.location {
//                newCharacterEntity.location = findOrCreateLocationEntity(fromLocationData: location)
//            }
//            
//            if let episode = character.episode {
//                var episodes =  [EpisodeEntity]()
//                episode.forEach { episode in
//                    let newEpisode = findOrCreateEpisode(from: episode)
//                    newCharacterEntity.addToEpisode(newEpisode)
//                }
//            }
//            
//            saveContext()
//        } catch {
//            print("Failed to fetch or save character: \(error)")
//        }
//    }
//    
// MARK: -- create
    
    func findOrCreateLocationEntity(fromLocationData location: LocationData) -> LocationEntity {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", location.url)
        fetchRequest.fetchLimit = 1

        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }

        let newLocation = LocationEntity(context: context)
        newLocation.entityId = Int64(location.id)
        newLocation.name = location.name
        newLocation.url = location.url
        return newLocation
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
