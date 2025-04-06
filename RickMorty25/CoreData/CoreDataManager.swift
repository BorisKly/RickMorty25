//
//  CoreDataStack.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 05.04.2025.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RickMorty25")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("DB url -", storeDescription.url?.absoluteString)
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createOrUpdateCharacter(from model: CharacterData) {
        
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "url == %@", model.url)
        
        let defaultImage = UIImage(named: "photo") ?? UIImage()
        
        loadImage(from: model.image ?? "") { image in
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Failed to convert image to data")
                return
            }
            do {
                let results = try self.context.fetch(fetchRequest)
                
                if let existingCharacter = results.first {
                    print("Updating character with url: \(model.url)")
                    self.updateCharacter(existingCharacter, with: model, photo: imageData)
                } else {
                    print("Creating new character with url: \(model.url)")
                    self.saveNewCharacter(model, photo: imageData)
                }
            } catch {
                print("Failed to fetch or save character: \(error)")
            }
        }
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
