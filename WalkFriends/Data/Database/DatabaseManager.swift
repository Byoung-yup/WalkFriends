//
//  DatabaseManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import FirebaseFirestore
import RxSwift
import RxCocoa

enum DatabaseError: Error {
    case NotFoundUserError
    case DatabaseFetchError
}

final class DatabaseManager {
    
    private let db = Firestore.firestore()
    
}

// MARK: - UserProfileRepository

extension DatabaseManager: DataRepository {
    
    func fetchUserData() -> Observable<Result<Bool, DatabaseError>> {
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                do {
                    
                    guard let strongSelf = self else { return }
                    
                    let document = try await strongSelf.db.collection("Users").document(FirebaseService.shard.currentUser.uid).getDocument()
                    
                    guard document.exists, let data = document.data() else  {
                        observer.onNext(.failure(DatabaseError.NotFoundUserError))
                        observer.onCompleted()
                        return
                    }
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                    
                    FirebaseService.shard.UserProfle = decoded
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    
                } catch {
                    
                    try FirebaseService.shard.auth.signOut()
                    
                    observer.onNext(.failure(DatabaseError.DatabaseFetchError))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create { task.cancel() }
        }
    }
    
//    func fetchUserProfile(completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
//        print("fetchUserProfile")
//        db.collection("Users").document(FirebaseService.shard.currentUser.uid).getDocument { document, error in
//
//            if let document = document, document.exists {
//                let data = document.data()
//                print("data exists")
//                completion(.success(true))
//                                                do {
//                                                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
//                                                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
//                                                    completion(.success(decoded))
//                                                } catch {
//                                                    print("Decode error")
//                                                }
//            } else {
//                print("Data fetch error")
//                completion(.failure(DatabaseError.FetchError))
//            }
//            return
//        }
//
//    }
    
    func createUserProfile(with userProfile: UserProfile, completion: @escaping (Bool) -> Void) {
        
        db.collection("Users").document(FirebaseService.shard.currentUser.uid).setData(userProfile.toDomain()) { err in
            
            guard err == nil else {
                print("Set Data Error")
                completion(false)
                return
            }
            print("Set Data success")
            completion(true)
            return
        }
    }
    
//    func createMapData(with userData: UserMap, completion: @escaping (Result<String, DatabaseError>) -> Void) {
//
//        let uid = UUID().uuidString
//
//        db.collection("Maps").document(uid).setData(userData.toDomain(uid: uid)) { error in
//
//            guard error == nil else {
//                print("Set Data Error")
//                completion(.failure(DatabaseError.FetchError))
//                return
//            }
//
//            print("Set Data success")
//            completion(.success(uid))
//            return
//        }
//
//    }
    
    func createMapData(with userData: UserMap, uid: String, urls: [String]) {
            
        db.collection("Maps").document(uid).setData(userData.toDomain(uid: uid, urls: urls)) { error in
            
            guard error == nil else {
                print("Write Data Error")
                return
            }
            
            return
        }
        
    }
    
    func fetchMapListData() -> Observable<[MapList]> {
        
        return Observable.create { [weak self] (observer) in
            
            self?.db.collection("Maps").getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    observer.onError(DatabaseError.DatabaseFetchError)
                    return
                }
                
                var mapList: [MapList] = []
                
                for document in documents {
                    let data = document.data()
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                        let decoded = try JSONDecoder().decode(MapList.self, from: jsonData)
                        mapList.append(decoded)
                    } catch let err {
                        print("Decode error: \(err)")
                    }
                }
                
                observer.onNext(mapList)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
}
