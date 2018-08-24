//
//  Thumbnail+CoreDataProperties.swift
//  
//
//  Created by Rahul Gupta on 24/08/18.
//
//

import Foundation
import CoreData


extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var source: String?

}
