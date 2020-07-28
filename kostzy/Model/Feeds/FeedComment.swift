//
//  FeedComment.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct FeedComment {
    
    var user : User
    var time: Date
    var comment: String
    
    init(user: User, time: Date, comment: String) {
        self.user = user
        self.time = time
        self.comment = comment
    }
    
    static func initData() -> [FeedComment] {
        var comments = [FeedComment]()
        comments.append(FeedComment(user: User.initUser(), time: Date(), comment: "Dummy Comment #1"))
        comments.append(FeedComment(user: User.initUser(), time: Date(), comment: "Dummy Comment #2"))
        comments.append(FeedComment(user: User.initUser(), time: Date(), comment: "Dummy Comment #3"))
        return comments
    }
    
}
