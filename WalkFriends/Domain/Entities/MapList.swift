//
//  MapList.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation

struct MapList: Decodable {
    let uid: String
    let address: String
    let imageUrls: [String]
    let title: String
    let subTitle: String
    let date: String
    let email: String
    let popular: Int
    let distance: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case address = "address"
        case title = "title"
        case subTitle = "subTitle"
        case imageUrls = "imageUrls"
        case date = "time"
        case email = "email"
        case popular = "popular"
        case distance = "distance"
        case time = "titme"
    }
}
