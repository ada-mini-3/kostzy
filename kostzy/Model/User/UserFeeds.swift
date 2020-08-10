//
//  User.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation
import UIKit

struct UserFeeds: Codable {
    
    var name: String
    var image: String?
    let exp: Int
    
}

var userImage: String?
var userFullName: String?
var userTitle: String?
//var userLike: Int?
var userAboutMe: String?
