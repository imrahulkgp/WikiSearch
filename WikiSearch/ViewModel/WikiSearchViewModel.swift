//
//  WikiSearchViewModel.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

protocol WikiSearchViewModelDelegate: class {
    func searchResultListUpdated()
    func failedToGetData()
}

class WikiSearchViewModel {
    
    weak var delegate: WikiSearchViewModelDelegate?
    
    var cachedPageIdList = [Int64]()
    
    var searchResultList: [PageDataItem]? {
        didSet {
            self.delegate?.searchResultListUpdated()
        }
    }
    
    var searchText: String = "" {
        didSet {
            self.getArticles(forKey: searchText)
        }
    }
    
    var articleCount: Int {
        get {
            if searchText.count > 0 {
                return self.searchResultList?.count ?? 0
            }
            return 0
        }
    }
    
    func cacheArticle(_ article: PageDataItem) {
        WSCoreDataManager.shared.cacheArticle(articleArray: [article]) { (success) in
            self.cachedPageIdList.append(article.pageid)
            print("cached \(article.title)")
        }
    }
    
    //TODO: Due to lack of time couldn't complete storing HTML into local file and loading in a webview.
//    func cachePost(_ article: PageDataItem) {
//        // Determile cache file path
//        var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
//        let filePath: String = "\(paths[0])/\(self.getURL(article: article))\(".html")"
//
//        // Download and write to file
//        let url:URL = URL(string: self.getURL(article: article))!
//        let urlData =  NSData(contentsOf: url as URL)
//        urlData?.write(toFile: filePath, atomically: true)
//    }
    
    func isAlreadySaved(_ article: PageDataItem) -> Bool {
        return WSCoreDataManager.shared.doesArticleExist(article)
    }
    
    func getURL(article: PageDataItem) -> String {
        return WSAppConstant.kOpenArticlePageURL.appending(article.title.replacingOccurrences(of: " ", with: "_"))
    }
    
    func fetchAllPageIds() {
        cachedPageIdList = WSCoreDataManager.shared.fetchAllCachedPageIds()
    }
    
    func getArticles(forKey key: String) {
        if key.count > 0 {
            let param = [ WSAppConstant.kAction: WSAppConstant.kQuery,
                          WSAppConstant.kFormat : WSAppConstant.kJson,
                          WSAppConstant.kProp : WSAppConstant.kPropValue,
                          WSAppConstant.kGenerator: WSAppConstant.kGeneratorValue,
                          WSAppConstant.kFormatVersion: WSAppConstant.kFormatVersionValue,
                          WSAppConstant.kPiprop: WSAppConstant.kThumbnail,
                          WSAppConstant.kPiThumbSize: WSAppConstant.kPiThumbSizeValue,
                WSAppConstant.kWbptTerms: WSAppConstant.kWbptTermsValue,
                WSAppConstant.kGpsSearch: key] as [String : Any]
            WSNetworkManager.sharedManager.sendUniqueRequest(HTTPMethod.get, url: WSAppConstant.kFetchArticlesURL, param: param, headers: nil) { [weak self] (data, response, error) in
                if let _ = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let articleResponse = try decoder.decode(SearchResultDataItem.self, from: data!)
                        if let _ = articleResponse.query {
                            self?.searchResultList = articleResponse.query?.pages
                        } else {
                            self?.searchResultList?.removeAll()
                        }
                    }
                    catch {
                        self?.delegate?.failedToGetData()
                        print("Error: \(error)")
                    }
                } else {
                    self?.delegate?.failedToGetData()
                }
            }
        } else {
            self.searchResultList?.removeAll()
        }
        
    }
    
}
