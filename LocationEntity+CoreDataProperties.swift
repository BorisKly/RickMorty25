//
//  LocationEntity+CoreDataProperties.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//
//

import Foundation
import CoreData

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {

}

extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var created: String?
    @NSManaged public var dimension: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String
    @NSManaged public var residents: NSSet?

}

// MARK: Generated accessors for residents
extension LocationEntity {

    @objc(addResidentsObject:)
    @NSManaged public func addToResidents(_ value: CharacterEntity)

    @objc(removeResidentsObject:)
    @NSManaged public func removeFromResidents(_ value: CharacterEntity)

    @objc(addResidents:)
    @NSManaged public func addToResidents(_ values: NSSet)

    @objc(removeResidents:)
    @NSManaged public func removeFromResidents(_ values: NSSet)

}

extension LocationEntity: Identifiable {
}
