//
//  User.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    static func initUser() -> User {
        return User(name: "Desti", image: #imageLiteral(resourceName: "destong"))
    }
    
}

var userImage: String?
var userFullName: String?
var userTitle: String?
var userLike: Int?
var userAboutMe: String?
