//
//  NotifItem.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 04/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

class NotifStore {
    static let shared = NotifStore()
    
    var items: [NotifItem] = []
    
    init() {
        loadItemsFromCache()
    }
    
    func add(item: NotifItem) {
        items.insert(item, at: 0)
        saveItemsToCache()
    }
}


// MARK: Persistance
extension NotifStore {
  func saveItemsToCache() {
    do {
      let data = try JSONEncoder().encode(items)
      try data.write(to: itemsCache)
    } catch {
      print("Error saving news items: \(error)")
    }
  }
  
  func loadItemsFromCache() {
    do {
      guard FileManager.default.fileExists(atPath: itemsCache.path) else {
        print("No news file exists yet.")
        return
      }
      let data = try Data(contentsOf: itemsCache)
      items = try JSONDecoder().decode([NotifItem].self, from: data)
    } catch {
      print("Error loading news items: \(error)")
    }
  }
  
  var itemsCache: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
    return documentsURL.appendingPathComponent("news.dat")
  }
}
