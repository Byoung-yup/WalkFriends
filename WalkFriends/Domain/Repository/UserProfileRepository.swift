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
    func createUserProfile(with userProfile: UserProfile, completion: @escaping (Bool) -> Void)
//    func createMapData(with userData: UserMap, completion: @escaping (Result<String, DatabaseError>) -> Void)
    func createMapData(with userData: UserMap, uid: String, urls: [String]) 
    func fetchMapListData() -> Observable<[MapList]>
}

protocol ImageRepository {
    func uploadImageData(with data: Data, completion: @escaping (Bool) -> Void)
//    func uploadImageArrayData(with data: [Data], uid: String, completion: @escaping (Result<Bool, DatabaseError>) -> Void)
    func uploadImageArrayData(with data: [Data], uid: String) -> Observable<[String]>
//    func downLoadImages(uid: String) -> [URL]
}

protocol NetworkService {
//    func dataTask(url: String) -> Observable<Data>
}

