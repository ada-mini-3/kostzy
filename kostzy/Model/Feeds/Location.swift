//
//  Location.swift
//  kostzy
//
//  Created by Rais on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

enum LocationType {
    case university, area
}

struct Location {
    
    var name: String
    var type: LocationType
    var lat: Double
    var long: Double
    
    init(name: String, type: LocationType, lat: Double, long: Double) {
        self.name = name
        self.type = type
        self.lat = lat
        self.long = long
    }
    
    static func initData() -> [Location] {
        var locations = [Location]()
        locations.append(Location(name: "Binus University, Kemanggisan", type: .university, lat: 22, long: 25))
        locations.append(Location(name: "Stan Jakarta", type: .university,  lat: 22, long: 25))
        locations.append(Location(name: "Trisakti University", type: .university,  lat: 22, long: 25))
        locations.append(Location(name: "Tarumanegara University", type: .university,  lat: 22, long: 25))
        locations.append(Location(name: "University of Indonesia", type: .university,  lat: 22, long: 25))
        
        locations.append(Location(name: "Cawang", type: .area, lat: 22, long: 10))
        locations.append(Location(name: "Palmerah", type: .area, lat: 22, long: 10))
        locations.append(Location(name: "Slipi", type: .area, lat: 22, long: 10))
        locations.append(Location(name: "Cengkareng", type: .area, lat: 22, long: 10))
        locations.append(Location(name: "Benhil", type: .area, lat: 22, long: 10))

        return locations
    }
    
}
