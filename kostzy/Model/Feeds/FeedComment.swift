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
    
}
