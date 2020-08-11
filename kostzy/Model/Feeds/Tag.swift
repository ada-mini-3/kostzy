//
//  Tag.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Tag: Codable {
    
    var id: Int
    var name: String
    var color: String

    init(id: Int,name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case color = "color"
    }
    
    static func initData() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(id: 1, name: "Facility", color: "#f34d71"))
        tags.append(Tag(id: 2, name: "Environment", color: "#2A8BD3"))
        tags.append(Tag(id: 3, name: "Price", color: "#21c2ca"))
        tags.append(Tag(id: 4, name: "Location", color: "#8346e5"))
        tags.append(Tag(id: 5, name: "Safety", color: "#72cdbf"))
        return tags
    }
    
    static func initCulinaryTag() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(id: 6, name: "Price", color: "#f34d71"))
        tags.append(Tag(id: 7, name: "Portion", color: "#2A8BD3"))
        tags.append(Tag(id: 8, name: "Taste", color: "#21c2ca"))
        tags.append(Tag(id: 9, name: "View", color: "#8346e5"))
        tags.append(Tag(id: 10, name: "Vegetarian", color: "#72cdbf"))
       return tags
    }
    
    static func initHangoutsTag() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(id: 11, name: "Wifi", color: "#f34d71"))
        tags.append(Tag(id: 12, name: "Ambience", color: "#2A8BD3"))
        tags.append(Tag(id: 13, name: "Price", color: "#21c2ca"))
        tags.append(Tag(id: 14, name: "Food", color: "#8346e5"))
        tags.append(Tag(id: 15, name: "Comfort", color: "#72cdbf"))
       return tags
    }
    
    static func initExpTag() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(id: 16, name: "Funny", color: "#f34d71"))
        tags.append(Tag(id: 17, name: "Hacks", color: "#2A8BD3"))
        tags.append(Tag(id: 18, name: "Upsetting", color: "#21c2ca"))
        tags.append(Tag(id: 19, name: "Sad", color: "#8346e5"))
        tags.append(Tag(id: 20, name: "Happy", color: "#72cdbf"))
       return tags
    }
    
}
