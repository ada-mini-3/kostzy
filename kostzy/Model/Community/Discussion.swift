//
//  Discussion.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Discussion: Codable {
    
    let id: Int
    let communityId : Int
    let user: UserFeeds
    let text: String
    let date: String
    var likeStatus: Bool
    let likeCount: Int
    let commentCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "user"
        case date = "date"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case communityId = "community"
        case likeStatus = "like_status"
        case text = "text"
    }
    
}

var postTime = ["5 hours ago",
                "13 hours ago",
                "15 days ago",
                "25 days ago",
                "30 days ago"]
var discussion = ["Bubur ayam pasundan biasanya buka jamberapa deh guys? BM bgt gila udah setahun gamakan bubur itu :(",
                  "Ada yang punya emergency lamp ga guys? Pinjem dong.. Butuh banget :(",
                  "Guys.. Semalem jam 2an gw lewat depan bambu sendirian trs ada putih2 terbang dong :(",
                  "Guyss setuju ga kalo di area Anggrek Cakra ini kita bikin kolam renang + tempat gym khusus untuk kita? Yang setuju like yah.. Kira-kira kyk gini sih gambarannya",
                  "Tes 1, 2, 3"]
var discussionImage = ["Discussion Photo 1",
                       "Discussion Photo 1"]
var commentCount = [8,
                    4,
                    45,
                    89,
                    90]
var likeCount = [2,
                 10,
                 10,
                 20,
                 30]
