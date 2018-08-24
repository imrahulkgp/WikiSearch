//
//  OfflineViewModel.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 24/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

protocol OfflineViewModelDelegate: class {
    func offlineArticleListUpdated()
}

class OfflineViewModel {

    weak var delegate: OfflineViewModelDelegate?
    
    var offlineArticleList: [PageDataItem]? {
        didSet {
            self.delegate?.offlineArticleListUpdated()
        }
    }
    
    func fetchCachedArticles() {
        self.offlineArticleList = WSCoreDataManager.shared.fetchArticle()
    }
    
    func getURL(article: PageDataItem) -> String {
        return WSAppConstant.kOpenArticlePageURL.appending(article.title.replacingOccurrences(of: " ", with: "_"))
    }

}
