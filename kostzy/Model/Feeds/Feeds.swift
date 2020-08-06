//
//  Feeds.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Feeds: Codable {
    
    var user: User
    var time: String
    var location: String?
    var feed: String
    var tags: [Tag]
    var likeCount: Int
    var commentCount: Int
    var category: Int
    var likeStatus : Bool

    init(user: User, time: String, location: String?, feed: String, tags: [Tag],
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
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case time = "date"
        case location = "location_name"
        case feed = "feed"
        case tags = "tags"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case category = "category"
        case likeStatus = "like_status"
    }
    
    static func initData() -> [Feeds] {
        var feeds = [Feeds]()
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Gua recommend banget kost Mandala. Fasilitasnya lengkap dan tau ga sih harganya perbulan cuman 1.5jt!", tags: [Tag.initData()[0], Tag.initData()[1]], likeCount: 10, commentCount: 4, category: 1, likeStatus: false))
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Kost ini lumayan deket dari binus Anggrek, deket lagi sama d’cost. Mantap", tags: [Tag.initData()[0], Tag.initData()[2]], likeCount: 10, commentCount: 4, category: 1, likeStatus: true))
        
        return feeds
    }
    
    static func initFeedCatData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Gue recommend banget ketoprak nya,  porsi nya banyak tapi enak, pokoknya worth it paraaah!", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 4, commentCount: 2, category: 2, likeStatus: false))
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Here is what user share/ask about  culinary around the area", tags: [Tag.initData()[2], Tag.initData()[1]], likeCount: 5, commentCount: 3, category: 2, likeStatus: false))
        
        return feeds
    }
    
    static func initFeedExpData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Kemaren gue ke cortado dan rameee bangeeet. Tempatnya sih bagus yah tapi wifi nya jadi lelet bangettt gajadi nugas gue", tags: [Tag.initData()[4], Tag.initData()[1]], likeCount: 4, commentCount: 2, category: 3, likeStatus: false))
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Tempat asik buat nugas di deket binus anggrek, ada nih namanya 9 square! Wifi nya cepet bgt!", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 5, commentCount: 3, category: 3, likeStatus: false))
        
        return feeds
    }
    
    static func initFeedHangoutsData() -> [Feeds] {
        var feeds = [Feeds]()
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Bener deh kalo kalian punya botol plastik sisa minuman, jangan dibuang! Jadiin rak sepatu aja daripada beli kan mahal", tags: [Tag.initData()[4], Tag.initData()[1]], likeCount: 4, commentCount: 2, category: 4, likeStatus: false))
        
        feeds.append(Feeds(user: User.initUser(), time: "2019-10-07", location: "Syahdan", feed: "Here is what user share/ask about  their kost experience around the area", tags: [Tag.initData()[3], Tag.initData()[4]], likeCount: 5, commentCount: 3, category:4, likeStatus: false))
        
        return feeds
    }
    
    
    
}
