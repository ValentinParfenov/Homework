//
//  Tasks+CoreDataProperties.swift
//  
//
//  Created by Валентин on 16.09.2021.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var title: String?

}
