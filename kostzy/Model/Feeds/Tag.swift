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
    
    static var colorArr =  [UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1),
    UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1),
    UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1),
    UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1),
    UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)]
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
    static func initData() -> [Tag] {
        var tags = [Tag]()
        tags.append(Tag(name: "Facility", color: UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1)))
        tags.append(Tag(name: "Environtment", color: UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)))
        tags.append(Tag(name: "Price", color: UIColor(red: 33/255, green: 193/255, blue: 202/255, alpha: 1)))
        tags.append(Tag(name: "Location", color: UIColor(red: 130/255, green: 70/255, blue: 229/255, alpha: 1)))
        tags.append(Tag(name: "Safety", color: UIColor(red: 114/255, green: 205/255, blue: 192/255, alpha: 1)))
        return tags
    }
}
