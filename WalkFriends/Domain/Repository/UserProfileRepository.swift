//
//  UserProfileRepository.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/09.
//

import Foundation
import RxSwift

protocol UserProfileRepository {
    func fetchUserProfile(completion: @escaping (Result<UserProfile, DatabaseError>) -> Void)
    func createUserProfile(with userProfile: UserProfile)
}
