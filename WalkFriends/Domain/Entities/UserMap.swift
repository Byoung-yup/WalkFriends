//
//  UserMap.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
import UIKit

struct UserMap {
    let address: String
    let images: [UIImage]
    let title: String
    let subTitle: String
}

extension UserMap {
    
    func toJSON(uid: String, urls: [String]) -> [String: Any] {
        
        return [
           "uid": uid,
           "email": FirebaseService.shard.currentUser.email!,
           "address": address,
           "title": title,
           "subTitle": subTitle,
           "time": Date().getCurrenTime(),
           "imageUrls": urls
        ]
    }
}
