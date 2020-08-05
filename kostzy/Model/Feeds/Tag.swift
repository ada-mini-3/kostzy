//
//  Tag.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Tag: Codable {
    
    var name: String
    var color: String

    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case color = "color"
    }
    
    static func initData() -> [Tag] {
        var tags = [Tag]()
        //#f34d71
        tags.append(Tag(name: "Facility", color: "#f34d71"))
        //#2A8BD3
        tags.append(Tag(name: "Environment", color: "#2A8BD3"))
        //#21c2ca
        tags.append(Tag(name: "Price", color: "#21c2ca"))
        //#8346e5
        tags.append(Tag(name: "Location", color: "#8346e5"))
        //#72cdbf
        tags.append(Tag(name: "Safety", color: "#72cdbf"))
        return tags
    }
    
    static func initCulinaryTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Price", color: "#f34d71"))
       tags.append(Tag(name: "Portion", color: "#2A8BD3"))
       tags.append(Tag(name: "Taste", color: "#21c2ca"))
       tags.append(Tag(name: "View", color: "#8346e5"))
       tags.append(Tag(name: "Vegetarian", color: "#72cdbf"))
       return tags
    }
    
    static func initHangoutsTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Wifi", color: "#f34d71"))
       tags.append(Tag(name: "Ambience", color: "#2A8BD3"))
       tags.append(Tag(name: "Price", color: "#21c2ca"))
       tags.append(Tag(name: "Food", color: "#8346e5"))
       tags.append(Tag(name: "Comfort", color: "#72cdbf"))
       return tags
    }
    
    static func initExpTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Funny", color: "#f34d71"))
       tags.append(Tag(name: "Hacks", color: "#2A8BD3"))
       tags.append(Tag(name: "Upsetting", color: "#21c2ca"))
       tags.append(Tag(name: "Sad", color: "#8346e5"))
       tags.append(Tag(name: "Happy", color: "#72cdbf"))
       return tags
    }
    
}
