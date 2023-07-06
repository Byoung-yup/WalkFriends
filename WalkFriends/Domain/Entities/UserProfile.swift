//
//  UserProfile.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import UIKit

public struct UserProfile: Decodable {
    let email: String
    let nickName: String
}

//extension UserProfile {
//    
//    func toDomain() -> [String: Any] {
//        
//        return [
//            "email": email,
//            "nickName": nickName,
//            "gender": gender
//        ]
//    }
//}
