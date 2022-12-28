//
//  ToDoList+CoreDataProperties.swift
//  CalenderCode
//
//  Created by SAWAN RANA RAMVEER SINGH on 15/03/22.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var date: Date?
    @NSManaged public var task: String?

}

extension ToDoList : Identifiable {

}
