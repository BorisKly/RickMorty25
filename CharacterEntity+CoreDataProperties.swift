//
//  CharacterEntity+CoreDataProperties.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {

}

extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var created: String?
    @NSManaged public var entityId: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String
    @NSManaged public var photo: Data?
    @NSManaged public var origin: LocationEntity?
    @NSManaged public var location: LocationEntity?
    @NSManaged public var episode: NSSet?

}

// MARK: Generated accessors for episode
extension CharacterEntity {

    @objc(addEpisodeObject:)
    @NSManaged public func addToEpisode(_ value: EpisodeEntity)

    @objc(removeEpisodeObject:)
    @NSManaged public func removeFromEpisode(_ value: EpisodeEntity)

    @objc(addEpisode:)
    @NSManaged public func addToEpisode(_ values: NSSet)

    @objc(removeEpisode:)
    @NSManaged public func removeFromEpisode(_ values: NSSet)

}

extension CharacterEntity: Identifiable {
}
