//
//  NotifItem.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 04/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct NotifItem: Codable {
    let title: String
    let date: Date
    let link: String
    
    @discardableResult
    static func makeNotifItem(_ notification: [String: AnyObject]) -> NotifItem? {
        guard let notif = notification["alert"] as? String,
              let url = notification["link_url"] as? String else {
            return nil
        }
      
        let notifItem = NotifItem(title: notif, date: Date(), link: url)
        let notifStore = NotifStore.shared
        notifStore.add(item: notifItem)
      
        NotificationCenter.default.post(name: NotificationVC.refreshNotification, object: self)
      
        return notifItem
    }
    
    
}
