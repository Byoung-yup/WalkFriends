//
//  MapList.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation

struct MapList: Codable {
    let uid: String
    let address: String
//    let images: [Data]?
    let title: String
    let subTitle: String
    let date: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case address = "address"
        case title = "title"
        case subTitle = "subTitle"
        case date = "time"
        case email = "email"
    }
}
