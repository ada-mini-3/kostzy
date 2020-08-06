//
//  User.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    
    var name: String
    var image: String?
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
    }
    
    static func initUser() -> User {
        return User(name: "Desti", image: "destong")
    }
    
}

var userImage: String?
var userFullName: String?
var userTitle: String?
var userLike: Int?
var userAboutMe: String?
