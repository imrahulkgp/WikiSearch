//
//  ThumbnailDataItem.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

struct ThumbnailDataItem: Codable {
    var source: String
    
    public init?(thumbnailCDObject: Thumbnail) {
        guard let source = thumbnailCDObject.source else {
            return nil
        }
        self.source = source
    }
    
}
