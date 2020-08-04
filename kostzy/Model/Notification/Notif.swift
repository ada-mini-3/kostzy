//
//  Notification.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 03/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Notif: Codable {
    var date: Date
    var userImage: String /*= ["Other User 1",
                               "Other User 2",
                               "Other User 2",
                               "Other User 3"]*/
    var userName: String /*= ["Eleanor",
                              "Kahfi",
                              "Kahfi",
                              "Justin"]*/
    var time: String /*= ["Now",
                          "10m",
                          "11m",
                          "20m"]*/
    var userComment: String /*= ["Liked your post.",
                                  "Commented: Itu emang tempatnya pewe banget sih gilaa",
                                  "Liked your post.",
                                  "Liked your post"]*/
    
//    init(date: Date, userImage: String, userName: String, time: String, userComment: String) {
//        self.date = date
//        self.userImage = userImage
//        self.userName = userName
//        self.time = time
//        self.userComment = userComment
//    }
//
//    static func initNotif() -> [Notif] {
//        var notification = [Notif]()
//        notification.append(Notif(date: "Today", userImage: "Other User 1", userName: "Eleanor", time: "Now", userComment: "Liked your post"))
//        notification.append(Notif(date: "Today", userImage: "Other User 2", userName: "Kahfi", time: "10m", userComment: "Commented: Itu emang tempatnya pewe banget sih gilaa"))
//        notification.append(Notif(date: "Today", userImage: "Other User 2", userName: "Kahfi", time: "11m", userComment: "Liked your post"))
//        notification.append(Notif(date: "Today", userImage: "Other User 3", userName: "Justin", time: "20m", userComment: "Liked your post"))
//
//        return notification
//    }
    
    
}
