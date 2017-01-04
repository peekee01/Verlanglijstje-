//
//  Counter+CoreDataProperties.swift
//  DreamLister
//
//  Created by Pieter Kuijsten on 03/01/2017.
//  Copyright © 2017 Pieter Kuijsten. All rights reserved.
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter");
    }

    @NSManaged public var counter: String?

}
