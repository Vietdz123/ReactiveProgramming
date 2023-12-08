//
//  ItemHome+CoreDataProperties.swift
//  WidgetEztttExtension
//
//  Created by Duc on 30/11/2023.
//
//

import Foundation
import CoreData


extension ItemHome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemHome> {
        return NSFetchRequest<ItemHome>(entityName: "ItemHome")
    }

    @NSManaged public var creationDate: Double
    @NSManaged public var family: String?
    @NSManaged public var name: String?
    @NSManaged public var routine_type: String?

}

extension ItemHome : Identifiable {

}
