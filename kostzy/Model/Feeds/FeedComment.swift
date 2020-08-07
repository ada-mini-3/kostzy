//
//  FeedComment.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct FeedComment: Codable {
    
    var user : UserFeeds
    var date: String
    var comment: String
    
    init(user: UserFeeds, time: String, comment: String) {
        self.user = user
        self.date = time
        self.comment = comment
    }
    
    static func initData() -> [FeedComment] {
        var comments = [FeedComment]()
        comments.append(FeedComment(user: UserFeeds.initUser(), time: "", comment: "Dummy Comment #1"))
        comments.append(FeedComment(user: UserFeeds.initUser(), time: "", comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,"))
        comments.append(FeedComment(user: UserFeeds.initUser(), time: "", comment: "Dummy Comment #3"))
        return comments
    }
    
}
