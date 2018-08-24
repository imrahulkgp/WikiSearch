//
//  WSAppConstant.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation
import UIKit

struct WSAppConstant {
    static let kFetchArticlesURL = "https://en.wikipedia.org//w/api.php"
    static let kOpenArticlePageURL = "https://en.wikipedia.org/wiki/"
    static let kTitleText = "Wiki Search"
    static let kTableViewCellHeight:CGFloat = 100.0
    
    static let kAction = "action"
    static let kQuery = "query"
    
    static let kFormat = "format"
    static let kJson = "json"
    
    static let kProp = "prop"
    static let kPropValue = "pageimages|pageterms"
    
    static let kGenerator = "generator"
    static let kGeneratorValue = "prefixsearch"
    
    static let kFormatVersion = "formatversion"
    static let kFormatVersionValue = 2
    
    static let kPiprop = "piprop"
    static let kThumbnail = "thumbnail"
    
    static let kPiThumbSize = "pithumbsize"
    static let kPiThumbSizeValue = 200
    
    static let kWbptTerms = "wbptterms"
    static let kWbptTermsValue = "description"
    
    static let kGpsSearch = "gpssearch"

    static let kSearchAnimationDuration = 0.5
}
