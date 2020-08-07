//
//  Feeds.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Feeds: Codable {
    
    var id: Int
    var user: UserFeeds
    var time: String
    var location: String?
    var feed: String
    var tags: [Tag]
    var likeCount: Int
    var commentCount: Int
    var category: Int
    var likeStatus : Bool

    init(id: Int,user: UserFeeds, time: String, location: String?, feed: String, tags: [Tag],
         likeCount: Int, commentCount: Int, category: Int, likeStatus: Bool) {
        self.id = id
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
        case id = "id"
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
    
}
