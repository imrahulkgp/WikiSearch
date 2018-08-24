//
//  Page+CoreDataProperties.swift
//  
//
//  Created by Rahul Gupta on 24/08/18.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var pageid: Int64
    @NSManaged public var title: String?
    @NSManaged public var terms: Terms?
    @NSManaged public var thumbnail: Thumbnail?

}
