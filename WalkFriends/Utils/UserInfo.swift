//
//  UserInfo.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/24.
//

import Foundation
import UIKit
import FirebaseAuth

final class UserInfo {
    
    static let shared = UserInfo()
    
    let currentUser = FirebaseAuth.Auth.auth().currentUser

    var email: String {
        (currentUser?.email)!
    }
    
    var uid: String? {
        currentUser?.uid
    }

}
