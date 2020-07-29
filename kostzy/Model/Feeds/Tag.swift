//
//  Tag.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation
import UIKit
struct Tag {
    
    var name: String
    var color: UIColor

    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
    static func initData() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(name: "Facility", color: UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1)))
        tags.append(Tag(name: "Environment", color: UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)))
        tags.append(Tag(name: "Price", color: UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1)))
        tags.append(Tag(name: "Location", color: UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1)))
        tags.append(Tag(name: "Safety", color: UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)))
        return tags
    }
    
    static func initCulinaryTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Price", color: UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1)))
       tags.append(Tag(name: "Portion", color: UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)))
       tags.append(Tag(name: "Taste", color: UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1)))
       tags.append(Tag(name: "View", color: UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1)))
       tags.append(Tag(name: "Vegetarian", color: UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)))
       return tags
    }
    
    static func initHangoutsTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Wifi", color: UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1)))
       tags.append(Tag(name: "Ambience", color: UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)))
       tags.append(Tag(name: "Price", color: UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1)))
       tags.append(Tag(name: "Food", color: UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1)))
       tags.append(Tag(name: "Comfort", color: UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)))
       return tags
    }
    
    static func initExpTag() -> [Tag] {
        var tags = [Tag]()
       tags.append(Tag(name: "Funny", color: UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1)))
       tags.append(Tag(name: "Hacks", color: UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)))
       tags.append(Tag(name: "Upsetting", color: UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1)))
       tags.append(Tag(name: "Sad", color: UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1)))
       tags.append(Tag(name: "Happy", color: UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)))
       return tags
    }
    
}
