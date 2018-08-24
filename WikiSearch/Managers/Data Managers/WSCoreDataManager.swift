//
//  WSCoreDataManager.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation
import CoreData

class WSCoreDataManager: NSObject {
    static let shared = WSCoreDataManager()
    let context = WSCoreDataStack.sharedInstance
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    func cacheArticle(articleArray: [PageDataItem], completionBlock:@escaping (_ success:Bool) -> Void) {
        self.context.managedObjectContext.perform {
            for article in articleArray {
                let articleCDObject = NSEntityDescription.insertNewObject(forEntityName: String.init(describing: Page.self), into: self.context.managedObjectContext) as! Page
                articleCDObject.pageid = article.pageid
                articleCDObject.title = article.title
                articleCDObject.thumbnail = self.getThumbnail(thumb: article.thumbnail)
                articleCDObject.terms = self.getTerms(term: article.terms)
            }
            if self.context.save() {
                completionBlock(true)
            }
            else {
                completionBlock(false)
            }
        }
    }
    
    func doesArticleExist(_ article: PageDataItem) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String.init(describing: Page.self))
        request.predicate = NSPredicate(format: "pageid = %d", article.pageid)
        var pageCDObject: Page?
        request.returnsObjectsAsFaults = false
        do {
            pageCDObject = try self.context.managedObjectContext.fetch(request).first as? Page
        } catch let error as NSError {
            print(error)
        }
        return pageCDObject != nil
    }
    
    func fetchAllCachedPageIds() -> [Int64] {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: String.init(describing: Page.self))
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["pageid"]
        var list: [NSDictionary]?
        do {
            list = try self.context.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        var pageIdList = [Int64]()
        if let list = list {
            for item in list {
                pageIdList.append(item.value(forKey: "pageid") as! Int64)
            }
        }
        return pageIdList
    }
    
    
    func fetchArticle() -> [PageDataItem] {
        let sortDescriptor = NSSortDescriptor(key: "pageid", ascending: true)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String.init(describing: Page.self))
        request.sortDescriptors = [sortDescriptor]
        var articleArray = [PageDataItem]()
        request.returnsObjectsAsFaults = false
        do {
            let articleCDObjectArray = try self.context.managedObjectContext.fetch(request) as! [Page]
            for article in articleCDObjectArray {
                if let articleDataItem = PageDataItem.init(pageCDObject: article) {
                    articleArray.append(articleDataItem)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return articleArray
    }
    
    func getThumbnail(thumb: ThumbnailDataItem?) -> Thumbnail? {
        guard let thumbnail = thumb else {
            return nil
        }
        let thumbnailCDObject = NSEntityDescription.insertNewObject(forEntityName: String.init(describing: Thumbnail.self), into: self.context.managedObjectContext) as! Thumbnail
        thumbnailCDObject.source = thumbnail.source
        return thumbnailCDObject
    }
    
    func getTerms(term: TermsDataItem?) -> Terms? {
        guard let terms = term else {
            return nil
        }
        let termsCDObject = NSEntityDescription.insertNewObject(forEntityName: String.init(describing: Terms.self), into: self.context.managedObjectContext) as! Terms
        termsCDObject.desc = terms.description.first
        return termsCDObject
    }
    
}

