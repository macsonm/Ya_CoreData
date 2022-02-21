//
//  Organization+CoreDataProperties.swift
//  Ya_CoreData
//
//  Created by Maxim M on 21.02.2022.
//
//

import Foundation
import CoreData


extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var name: String?
    @NSManaged public var employee: Employee?

}

extension Organization : Identifiable {

}
