//
//  Terms+CoreDataProperties.swift
//  
//
//  Created by Rahul Gupta on 24/08/18.
//
//

import Foundation
import CoreData


extension Terms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Terms> {
        return NSFetchRequest<Terms>(entityName: "Terms")
    }

    @NSManaged public var desc: String?

}
