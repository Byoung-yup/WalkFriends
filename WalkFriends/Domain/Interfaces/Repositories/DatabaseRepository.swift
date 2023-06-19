//
//  UserProfileRepository.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/09.
//

import Foundation
import RxSwift
import FirebaseStorage


protocol DataRepository {
//    func fetchUserProfile(completion: @escaping (Result<Bool, DatabaseError>) -> Void)
    func fetchUserData() -> Observable<Result<Bool, DatabaseError>>
    func createUserProfile(with data: UserProfileData) async throws 
//    func createMapData(with userData: UserMap, completion: @escaping (Result<String, DatabaseError>) -> Void)
    func createMapData(with userData: UserMap, uid: String, urls: [String])
    func uploadMapData(with userData: UserMap, uid: String, urls: [String]) async throws
    func fetchMapListData() -> Observable<[MapList]>
}

protocol NetworkService {
//    func dataTask(url: String) -> Observable<Data>
}

