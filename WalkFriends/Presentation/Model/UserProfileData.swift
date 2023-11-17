//
//  UserProfileData.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/06/07.
//

import Foundation
import UIKit

public struct UserProfileData {
    let imageData: Data
    let nickName: String
}

extension UserProfileData {
    
    func toJSON() -> [String: Any] {
        
        return [
            "nickName": nickName,
            "favorite" : []
        ]
    }
}
