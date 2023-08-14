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
import FirebaseAuth

enum DatabaseError: Error {
    case NotFoundUserError
    case DatabaseFetchError
    case UnknownError
}

final class DatabaseManager {
    
    private let db = Firestore.firestore()
}

// MARK: - UserProfileRepository

extension DatabaseManager: DataRepository {
    
//    func fetchUserData() -> Observable<Result<Bool, DatabaseError>> {
//
//        return Observable.create { [weak self] (observer) in
//
//            let task = Task { [weak self] in
//
//                guard let strongSelf = self else { return }
//
//                do {
//
//                    let document = try await strongSelf.db.collection("Users").document((FirebaseService.shard.auth.currentUser?.uid)!).getDocument()
//                    print("current User Uid: \((FirebaseService.shard.auth.currentUser?.uid)!)")
//                    print("current User Email: \((FirebaseService.shard.auth.currentUser?.email)!)")
//                    guard document.exists, let data = document.data() else  {
//                        observer.onNext(.failure(DatabaseError.NotFoundUserError))
//                        observer.onCompleted()
//                        return
//                    }
//
//                    let jsonData = try JSONSerialization.data(withJSONObject: data)
//                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
//
//                    observer.onNext(.success(true))
//                    observer.onCompleted()
//
//                } catch let err {
//                    print("Fetch Error: \(err.localizedDescription)")
//                    try FirebaseAuth.Auth.auth().signOut()
//
//                    observer.onNext(.failure(DatabaseError.DatabaseFetchError))
//                    observer.onCompleted()
//                }
//            }
//
//            return Disposables.create { task.cancel() }
//        }
//    }
    
    func fetchUserData() async throws  {
        
        let document = try! await db.collection("Users").document((FirebaseService.shard.auth.currentUser?.uid)!).getDocument()
        
        guard document.exists else {
            try FirebaseService.shard.auth.signOut()
            throw DatabaseError.NotFoundUserError
        }
//        print("user Exist")
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
    
    func createUserProfile(with data: UserProfileData) async throws {
        
        do {
            try await db.collection("Users").document(FirebaseAuth.Auth.auth().currentUser!.uid).setData(data.toJSON())
        } catch {
            throw DatabaseError.UnknownError
        }
    }
        
        
        
        
//        return Observable.create { [weak self] (observer) in
//
//            guard let strongSelf = self else { return }
//
//            let task = Task {
//
//                do {
//
//                    try await strongSelf.db.document("Users").setData(data.toJSON())
//
//                    observer.onNext(.success(true))
//                    observer.onCompleted()
//
//                } catch {
//
//                    observer.onNext(.failure(DatabaseError.UnknownError))
//                    observer.onCompleted()
//
//                }
//            }
//
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
    
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
            
        db.collection("Maps").document(uid).setData(userData.toJSON(uid: uid, urls: urls)) { error in
            
            guard error == nil else {
                print("Write Data Error")
                return
            }
            
            return
        }
        
    }
    
    func uploadMapData(with userData: UserMap, uid: String, urls: [String]) async throws {
        
        do {
            try await db.collection("Maps").document(uid).setData(userData.toJSON(uid: uid, urls: urls))
        } catch {
            throw DatabaseError.UnknownError
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
    
    func fetchMapListData2() async throws -> [MapList?] {
        
        return try await withThrowingTaskGroup(of: MapList?.self) { group in
            
            let snapshot = try await db.collection("Maps").getDocuments()
            
            let documnets = snapshot.documents
            
            for documnet in documnets {
                
                let data = documnet.data()
                
                group.addTask {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                        return try JSONDecoder().decode(MapList.self, from: jsonData)
                    } catch let err {
                        print("err: \(err.localizedDescription)")
                        throw DatabaseError.UnknownError
                    }
                }
            }
            
            return try await group
                .reduce(into: [MapList?](), { $0.append($1) })
                .compactMap { $0 }
        }
    }
}
    

