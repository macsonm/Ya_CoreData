//
//  Organization+CoreDataProperties.swift
//  Ya_CoreData
//
//  Created by Maxim M on 06.03.2022.
//
//

import Foundation
import CoreData


extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var name: String?
    @NSManaged public var employee: NSSet?

}

// MARK: Generated accessors for employee
extension Organization {

    @objc(addEmployeeObject:)
    @NSManaged public func addToEmployee(_ value: Employee)

    @objc(removeEmployeeObject:)
    @NSManaged public func removeFromEmployee(_ value: Employee)

    @objc(addEmployee:)
    @NSManaged public func addToEmployee(_ values: NSSet)

    @objc(removeEmployee:)
    @NSManaged public func removeFromEmployee(_ values: NSSet)

}

extension Organization : Identifiable {

}
