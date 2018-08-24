//
//  PageDataItem.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

struct PageDataItem: Codable {
    var pageid: Int64
    var title: String
    var thumbnail: ThumbnailDataItem?
    var terms: TermsDataItem?
    
    public init?(pageCDObject: Page) {
        guard let title = pageCDObject.title,
            let thumbnail = pageCDObject.thumbnail,
            let terms = pageCDObject.terms else {
                return nil
        }
        self.pageid = pageCDObject.pageid
        self.title = title
        self.terms = TermsDataItem.init(termsCDObject: terms)
        self.thumbnail = ThumbnailDataItem.init(thumbnailCDObject: thumbnail)
    }
    
}
