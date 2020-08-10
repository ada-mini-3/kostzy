//
//  Feeds.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Feeds: Codable {
    
    let id: Int
    let user: UserFeeds
    let time: String
    let location: String?
    let feed: String
    let tags: [Tag]
    var likeCount: Int
    let commentCount: Int
    let category: Int
    var likeStatus : Bool
    let like: FeedLike?
    
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
        case like = "like"
    }
    
}
