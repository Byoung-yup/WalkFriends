//
//  UserProfile.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import UIKit

public struct UserProfile: Codable {
    let imageUrl: String
    let email: String
    let nickName: String
    let gender: String
    
    enum CodingKeys: CodingKey {
        case imageUrl
        case email
        case nickName
        case gender
    }
//    let favorite: [Favorite?]
//    let liking: Linking
//    let pet: Pet
}
//
//struct Favorite: Codable {
//    let uid: String?
//}
//
//struct Linking: Codable {
//    let up: Int
//    let down: Int
//}
//
//
//struct Pet: Decodable {
//    let name: String
//    let age: Int
//    let gender: String
//}

extension UserProfile {
    
    func toDomain() -> [String: Any] {
        
        return [
            "imageUrl": imageUrl,
            "email": email,
            "nickName": nickName,
            "gender": gender
        ]
    }
}
