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
////    func fetchUserProfile(completion: @escaping (Result<Bool, DatabaseError>) -> Void)
////    func fetchUserData() -> Observable<Result<Bool, DatabaseError>>
//    func fetchUserData(uid: String) async throws -> UserProfile
//    func createUserProfile(with data: UserProfileData) async throws 
////    func createMapData(with userData: UserMap, completion: @escaping (Result<String, DatabaseError>) -> Void)
//    func createMapData(with userData: UserMap, uid: String, urls: [String])
//    func uploadMapData(with userData: UserMap, uid: String, urls: [String]) async throws
//    func uploadMapData2(with userData: UserMap, uid: String) async throws
//    func fetchMapListData() -> Observable<[MapList]>
//    func fetchMapListData2() async throws -> [MapList?]
//    func fetchMapListData3() async throws -> [MapList]
    
    //
    func checkUser() -> Observable<Result<Bool, FBError>>
    func createUser(with data: UserProfileData) -> Observable<Result<Bool, FBError>>
}

protocol NetworkService {
//    func dataTask(url: String) -> Observable<Data>
}

