//
//  CoreDataStack.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 05.04.2025.
//

import CoreData

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

    func saveCharacter(from model: CharacterData) {

        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)
        
        loadImage(from: model.image ?? "") { image in
            guard let image = image, let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Failed to convert image to data.")
                return
            }
            do {
                let results = try self.context.fetch(fetchRequest)

                let character: CharacterEntity
                if let existingCharacter = results.first {
                    character = existingCharacter
                    print("Updating existing character with id \(model.id)")
                } else {
                    character = CharacterEntity(context: self.context)
                    character.id = model.id
                    print("Creating new character with id \(model.id)")
                }

                character.name = model.name
                character.status = model.status
                character.species = model.species
                character.type = model.type
                character.url = model.url
                character.created = model.created
                character.photo = imageData
                character.origin = model.origin
                character.location = model.location

                if let episodes = model.episodes {
                    character.episode = NSSet(array: episodes)
                }

                try self.context.save()
                print("Character saved successfully.")
            } catch {
                print("Failed to fetch or save character: \(error)")
            }
        }
    }
}
