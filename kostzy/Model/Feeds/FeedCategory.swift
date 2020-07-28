//
//  Category.swift
//  kostzy
//
//  Created by Rais on 28/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct FeedCategory {
    
    var id : Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func initData() -> [FeedCategory] {
        var categories = [FeedCategory]()
        
        categories.append(FeedCategory(id: 1, name: "Information"))
        categories.append(FeedCategory(id: 2, name: "Food"))
        categories.append(FeedCategory(id: 3, name: "Experience"))
        categories.append(FeedCategory(id: 4, name: "Hangouts"))
        
        return categories
    }
    
}
