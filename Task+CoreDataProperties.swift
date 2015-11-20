//
//  Task+CoreDataProperties.swift
//  TaskIt
//
//  Created by Isaiah Belle on 11/18/15.
//  Copyright © 2015 Isaiah Belle. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var mainTask: String?
    @NSManaged var completed: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var subTask: String?

}
