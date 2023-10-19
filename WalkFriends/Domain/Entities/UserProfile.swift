//
//  UserProfile.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import FirebaseStorage

struct UserProfile: Decodable {
    let email: String
    let nickName: String
    let favorite: [String]
    let uid: String
}


struct FinalUserProfile {
    let reference: StorageReference
    let profile: UserProfile
}
