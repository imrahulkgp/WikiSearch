//
//  TermsDataItem.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

struct TermsDataItem: Codable {
    var description: [String]
    
    public init?(termsCDObject: Terms) {
        guard let desc = termsCDObject.desc else {
                return nil
        }
        self.description = [desc]
    }
    
}
