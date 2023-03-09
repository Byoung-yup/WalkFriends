//
//  UserProfile.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation

public struct UserProfile: Codable {
    let email: String
    let nickName: String?
    let favorite: [Favorite]
    let liking: Linking
    let pet: Pet
}

struct Favorite: Codable {
    let uid: String?
}

struct Linking: Codable {
    let up: Int
    let down: Int
}


struct Pet: Codable {
    let name: String
    let age: Int
    let gender: String
}
