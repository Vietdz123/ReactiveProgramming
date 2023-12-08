//
//  CategoryHome+CoreDataProperties.swift
//  WidgetEztttExtension
//
//  Created by Duc on 30/11/2023.
//
//

import Foundation
import CoreData


extension CategoryHome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryHome> {
        return NSFetchRequest<CategoryHome>(entityName: "CategoryHome")
    }

    @NSManaged public var creationDate: Double
    
    @NSManaged public var currentIndexDigitalFriend: Double
    @NSManaged public var delayAnimation: Double
    @NSManaged public var digitalType: String?
    @NSManaged public var folderType: String?
    @NSManaged public var hasSound: Bool
    
    @NSManaged public var isFirstImage: Bool
    @NSManaged public var name: String?
    @NSManaged public var numberCheckedImages: Double
    @NSManaged public var numberImagesRect: Double
    @NSManaged public var numberImagesSquare: Double
    @NSManaged public var routineType: String?
    @NSManaged public var shouldPlaySound: Bool
    @NSManaged public var soundType: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension CategoryHome {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemHome)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemHome)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension CategoryHome : Identifiable {

}
