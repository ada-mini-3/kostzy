//
//  Community.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct Community: Codable {
    
    let id: Int
    let name: String
    let image: String
    let description: String
    let subtitle: String
    let location: String
    let lat: String
    let long: String
    let isJoined: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
        case description = "description"
        case subtitle = "subtitle"
        case location = "location"
        case lat = "lat"
        case long = "long"
        case isJoined = "is_joined"
    }
    
}


// MARK: - Array
var communityImage = ["Kost Area Anggrek Cakra",
                      "Kost Area Kijang",
                      "Kost Area Rawa Belong",
                      "Kost Area Sandang",
                      "Kost Area Syahdan",
                      "Kost Area U"]
var communityName = ["Kost Area Anggrek Cakra",
                     "Kost Area Kijang",
                     "Kost Area Rawa Belong",
                     "Kost Area Sandang",
                     "Kost Area Syahdan",
                     "Kost Area U"]
var communityBrief = ["Diskusi bebas seputaran daerah Anggrek Cakra. Yuk gabung!",
                      "Sini sini gausah malu-malu! Kita saling melengkapi aja yah :)",
                      "Mariiiiii anak kost sekitaran Rawa Belong berkumpul disini!",
                      "Eitssss yang bukan anak Sandang dilarang join :p",
                      "Yang kepo kepo tentang susahnya nge-kost di Syahdan cusss gabung.",
                      "UUUUUUUUUUUUUUUUUU? Mantap"]
var communityLocation = ["KEBON JERUK",
                         "KEBON JERUK",
                         "KEBON JERUK",
                         "KEBON JERUK",
                         "KEBON JERUK",
                         "KEBON JERUK"]
var communityPost = [33,
                     23,
                     13,
                     43,
                     53,
                     63]
var communityDescription = ["Khusus untuk kamu yang nge-kost di daerah Anggrek Cakra! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Anggrek Cakra. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)",
                            "Khusus untuk kamu yang nge-kost di daerah Kijang! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Kijang. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)",
                            "Khusus untuk kamu yang nge-kost di daerah Rawa Belong! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Rawa Belong. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)",
                            "Khusus untuk kamu yang nge-kost di daerah Sandang! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Sandang. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)",
                            "Khusus untuk kamu yang nge-kost di daerah Syahdan! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Syahdan. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)",
                            "Khusus untuk kamu yang nge-kost di daerah Anggrek Cakra! Community ini bertujuan untuk saling membantu, memberikan informasi, menemani, memahami, melayani, dan menyayangi sesama anak kost yang tinggal di area Syahdan. Jadiiiiii bagi anak kost yang tinggal di area ini langsung aja gabuuuunng dan rasakan manfaatnya :)"]
var communityAlbumImage = ["Album 1",
                           "Album 2",
                           "Album 3",
                           "Album 1",
                           "Album 2",
                           "Album 3"]
var memberCount = [27,
                   37,
                   47,
                   57,
                   17,
                   67]
var memberImage = ["Lala",
                   "Dinda",
                   "Fira",
                   "Rayhan",
                   "Rais",
                   "Lala"]
var memberName = ["Lala",
                  "Dinda",
                  "Fira",
                  "Rayhan",
                  "Rais",
                  "Lala"]
var memberRole = ["",
                  "",
                  "",
                  "",
                  "",
                  ""]
var memberIsAdmin = false
var communityIsRequested = [false,
                            false,
                            false,
                            false,
                            false,
                            false]
var communityIsJoined = [false,
                         false,
                         false,
                         false,
                         false,
                         false]
