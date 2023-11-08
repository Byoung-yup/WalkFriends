////
////  UserProfileData.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/06/07.
////
//
//import Foundation
//import UIKit
//
//public struct UserProfileData {
//    let image: UIImage
//    let email: String
//    let nickName: String
//}
//
//extension UserProfileData {
//    
//    func toJSON() -> [String: Any] {
//        
//        return [
//            "email": email,
//            "uid": FirebaseService.shard.auth.currentUser!.uid,
//            "nickName": nickName,
//            "favorite" : []
//        ]
//    }
//}
