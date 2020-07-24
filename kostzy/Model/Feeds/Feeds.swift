//
//  Feeds.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Feeds {
    
    var user: User
    var time: Date
    var location: String?
    var feed: String
    var tags: [Tag]
    var likeCount: Int
    var commentCount: Int
    var category: Int
    
    init(user: User, time: Date, location: String, feed: String, tags: [Tag],
         likeCount: Int, commentCount: Int, category: Int) {
        self.user = user
        self.time = time
        self.location = location
        self.feed = feed
        self.tags = tags
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.category = category
    }
    
    static func initData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Halo Semuanya nama abdi desti, salam kenal eaaa fjeiqfiowncincnciejnfiqicisancasin ici cijcq i cjiqjc ijc i", tags: [Tag(name: "Happy"), Tag(name: "Introduction")], likeCount: 10, commentCount: 4, category: 1))
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Keren Banget ini tempat", tags: [Tag(name: "Happy"), Tag(name: "Introduction")], likeCount: 10, commentCount: 4, category: 1))
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Makanan Enak", tags: [Tag(name: "Food"), Tag(name: "Nice")], likeCount: 10, commentCount: 4, category: 2))
        
        return feeds
    }
    
}
