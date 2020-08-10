//
//  DiscussionComment.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct DiscussionComment: Codable {
    
    var id: Int
    var user: UserFeeds
    var discussion: Int
    var comment: String
    var date: String
    
}
