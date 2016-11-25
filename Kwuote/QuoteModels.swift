//
//  QuoteModels.swift
//  Kwuote
//
//  Created by Carson Carbery on 11/17/16.
//  Copyright © 2016 Carson Carbery. All rights reserved.
//

import Foundation


struct Quote {
    let token: String
    let quoteId: Int
    let notifiedAt: Int
    let id: Int
    let quoteText: String
    let author: String
    let created: Int
    
    init?(JSON: [String : AnyObject]) {
        
        guard let token = JSON["token"] as? String,
            let quoteId = JSON["quoteId"] as? Int,
            let notifiedAt = JSON["notifiedAt"] as? Int,
            let id = JSON["id"] as? Int,
            let quoteText = JSON["text"] as? String,
            let author = JSON["author"] as? String,
            let created = JSON["created"] as? Int
        
        else {
                return nil
        }
        
        self.token = token
        self.quoteId = quoteId
        self.notifiedAt = notifiedAt
        self.id = id
        self.quoteText = quoteText
        self.author = author
        self.created = created
        
    }
}
