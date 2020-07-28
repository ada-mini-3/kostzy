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
    var likeStatus : Bool

    
    init(user: User, time: Date, location: String?, feed: String, tags: [Tag],
         likeCount: Int, commentCount: Int, category: Int, likeStatus: Bool) {
        self.user = user
        self.time = time
        self.location = location
        self.feed = feed
        self.tags = tags
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.category = category
        self.likeStatus = likeStatus
    }
    
    static func initData() -> [Feeds] {
        var feeds = [Feeds]()
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Halo Semuanya nama abdi desti, salam kenal eaaa", tags: [Tag.initData()[0], Tag.initData()[1]], likeCount: 10, commentCount: 4, category: 1, likeStatus: false))
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Keren Banget ini tempat", tags: [Tag.initData()[0], Tag.initData()[2]], likeCount: 10, commentCount: 4, category: 1, likeStatus: true))
        
        return feeds
    }
    
    static func initFeedCatData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Makanan Enak", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 4, commentCount: 2, category: 2, likeStatus: false))
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Ate Good Food", tags: [Tag.initData()[2], Tag.initData()[1]], likeCount: 5, commentCount: 3, category: 2, likeStatus: false))
        
        return feeds
    }
    
    static func initFeedExpData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Heilo All", tags: [Tag.initData()[4], Tag.initData()[1]], likeCount: 4, commentCount: 2, category: 3, likeStatus: false))
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Mlikum Semuanya", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 5, commentCount: 3, category: 3, likeStatus: false))
        
        return feeds
    }
    
    static func initFeedHangoutsData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Tempat Hangout yang enak dimana ya?", tags: [Tag.initData()[4], Tag.initData()[1]], likeCount: 4, commentCount: 2, category: 4, likeStatus: false))
        
        feeds.append(Feeds(user: User(name: "Desti", image: #imageLiteral(resourceName: "destong")), time: Date(), location: "Syahdan", feed: "Tempat hangout ini enak banget guys gila", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 5, commentCount: 3, category:4, likeStatus: false))
        
        return feeds
    }
    
    
    
}
