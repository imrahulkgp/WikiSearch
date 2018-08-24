//
//  WSCoreDataStack.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation
import CoreData

class WSCoreDataStack {
    
    static let sharedInstance = WSCoreDataStack()
    var persistentStoreName: String = (Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String)!
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as URL
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.persistentStoreName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var options = [NSMigratePersistentStoresAutomaticallyOption : true,
                       NSInferMappingModelAutomaticallyOption : true,
                       NSSQLitePragmasOption : ["journal_mode": "DELETE"]] as [String : Any]
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(self.persistentStoreName).sqlite")
        print("SQL_URL: \(url)")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            //dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var privateManagedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedContext.persistentStoreCoordinator = coordinator
        privateManagedContext.retainsRegisteredObjects = false
        privateManagedContext.undoManager = nil
        return privateManagedContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateContext
        managedObjectContext.retainsRegisteredObjects = false
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
    
    
    func save() -> Bool {
        if !self.privateContext.hasChanges && !self.managedObjectContext.hasChanges {
            return true
        }
        self.managedObjectContext.performAndWait({() -> Void in
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                assertionFailure("Error saving Managed context: \(error), \(error.userInfo)")
                return
            } catch {
                assertionFailure("Undefined error")
                return
            }
        })
        
        self.privateContext.perform({() -> Void in
            do {
                try self.privateContext.save()
            } catch let error as NSError {
                assertionFailure("Error saving Private context: \(error), \(error.userInfo)")
                return
            } catch {
                assertionFailure("Undefined error")
                return
            }
        })
        return true
    }
    
}
