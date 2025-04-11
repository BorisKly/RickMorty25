//
//  EpisodeEntity+CoreDataProperties.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 11.04.2025.
//
//

import Foundation
import CoreData

@objc(EpisodeEntity)
public class EpisodeEntity: NSManagedObject {

}

extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
    }

    @NSManaged public var airData: String?
    @NSManaged public var created: String?
    @NSManaged public var entityId: Int64
    @NSManaged public var episode: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String
    @NSManaged public var characters: NSSet?

}

// MARK: Generated accessors for characters
extension EpisodeEntity {

    @objc(addCharactersObject:)
    @NSManaged public func addToCharacters(_ value: CharacterEntity)

    @objc(removeCharactersObject:)
    @NSManaged public func removeFromCharacters(_ value: CharacterEntity)

    @objc(addCharacters:)
    @NSManaged public func addToCharacters(_ values: NSSet)

    @objc(removeCharacters:)
    @NSManaged public func removeFromCharacters(_ values: NSSet)

}

extension EpisodeEntity : Identifiable {

}
