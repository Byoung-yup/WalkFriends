//
//  UserProfileData.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/06/07.
//

import Foundation
import UIKit

public struct UserProfileData {
    let image: UIImage
    let email: String
    let nickName: String
    let gender: String
}

extension UserProfileData {
    
    func toJSON() -> [String: Any] {
        
        return [
            "email": email,
            "nickName": nickName,
            "gender": gender
        ]
    }
}
