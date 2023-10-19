//
//  UserMap.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
import UIKit
import FirebaseStorage

struct UserMap {
    let address: String
    let imageDatas: [Data]
//    let map_Image: UIImage
    let title: String
    let memo: String
    let time: String
    let popular: Int
}

extension UserMap {
    
    func toJSON(uid: String, urls: [String]) -> [String: Any] {
        
        return [
           "uid": uid,
           "email": (FirebaseService.shard.auth.currentUser?.email)!,
           "address": address,
           "title": title,
           "memo": memo,
           "time": time,
           "upload_Date": Date().getCurrenTime(),
           "imageUrls": urls,
           "popular": popular
        ]
    }
    
    func toJSON2(uid: String) -> [String: Any] {
        
        return [
           "uid": uid,
           "writer": FirebaseService.shard.auth.currentUser!.uid,
           "address": address,
           "title": title,
           "memo": memo,
           "time": time,
           "upload_Date": Date().getCurrenTime(),
           "popular": popular
        ]
    }
}
