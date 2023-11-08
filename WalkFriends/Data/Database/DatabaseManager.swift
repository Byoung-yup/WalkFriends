////
////  DatabaseManager.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/02/07.
////
//
import Foundation
import FirebaseFirestore
import RxSwift
import SwiftKeychainWrapper

enum DatabaseError: Error {
    case NotFoundUserError
    case DatabaseFetchError
    case UnknownError
    case ExistNicknameError
}
//
final class DatabaseManager {

    private let db = Firestore.firestore()
}
//
//// MARK: - UserProfileRepository
//
extension DatabaseManager: DataRepository {
    
    // MARK: Create User
    func createUser() -> Observable<Result<Bool, FBError>> {

        let uid = KeychainWrapper.standard.string(forKey: "UID") ?? ""
        
        return Observable.create { (observer) in
            
            Firestore.firestore().collection("Users").document("\(uid)").getDocument { (document, error) in
                
                guard error == nil else {
                    observer.onNext(.failure(.UnknownError))
                    observer.onCompleted()
                    return
                }
                
                guard let document = document, document.exists else {
                    observer.onNext(.success(false))
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }


    }
    //
    ////    func fetchUserData() -> Observable<Result<Bool, DatabaseError>> {
    ////
    ////        return Observable.create { [weak self] (observer) in
    ////
    ////            let task = Task { [weak self] in
    ////
    ////                guard let strongSelf = self else { return }
    ////
    ////                do {
    ////
    ////                    let document = try await strongSelf.db.collection("Users").document((FirebaseService.shard.auth.currentUser?.uid)!).getDocument()
    ////                    print("current User Uid: \((FirebaseService.shard.auth.currentUser?.uid)!)")
    ////                    print("current User Email: \((FirebaseService.shard.auth.currentUser?.email)!)")
    ////                    guard document.exists, let data = document.data() else  {
    ////                        observer.onNext(.failure(DatabaseError.NotFoundUserError))
    ////                        observer.onCompleted()
    ////                        return
    ////                    }
    ////
    ////                    let jsonData = try JSONSerialization.data(withJSONObject: data)
    ////                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
    ////
    ////                    observer.onNext(.success(true))
    ////                    observer.onCompleted()
    ////
    ////                } catch let err {
    ////                    print("Fetch Error: \(err.localizedDescription)")
    ////                    try FirebaseAuth.Auth.auth().signOut()
    ////
    ////                    observer.onNext(.failure(DatabaseError.DatabaseFetchError))
    ////                    observer.onCompleted()
    ////                }
    ////            }
    ////
    ////            return Disposables.create { task.cancel() }
    ////        }
    ////    }
    //
    //    func fetchUserData(uid: String) async throws -> UserProfile {
    //
    //        let document = try await db.collection("Users").document(uid).getDocument()
    //        print("document: \(document)")
    //        guard document.exists, let data = document.data() else {
    //            throw DatabaseError.NotFoundUserError
    //        }
    //        print("user Exist")
    //        do {
    //            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
    //            return try JSONDecoder().decode(UserProfile.self, from: jsonData)
    //        } catch let err {
    //            print("err: \(err.localizedDescription)")
    //            throw DatabaseError.UnknownError
    //        }
    //    }
    //
    ////    func fetchUserProfile(completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
    ////        print("fetchUserProfile")
    ////        db.collection("Users").document(FirebaseService.shard.currentUser.uid).getDocument { document, error in
    ////
    ////            if let document = document, document.exists {
    ////                let data = document.data()
    ////                print("data exists")
    ////                completion(.success(true))
    ////                                                do {
    ////                                                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
    ////                                                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
    ////                                                    completion(.success(decoded))
    ////                                                } catch {
    ////                                                    print("Decode error")
    ////                                                }
    ////            } else {
    ////                print("Data fetch error")
    ////                completion(.failure(DatabaseError.FetchError))
    ////            }
    ////            return
    ////        }
    ////
    ////    }
    //
    //    func createUserProfile(with data: UserProfileData) async throws {
    //
    //        guard let uid = FirebaseService.shard.auth.currentUser?.uid else {
    //            throw DatabaseError.UnknownError
    //        }
    //
    //        do {
    //            let snapshot = try await db.collection("Users").whereField("nickName", isEqualTo: data.nickName).getDocuments()
    //
    //            // 닉네임 중복 여부
    //            guard snapshot.documents.isEmpty else {
    //                throw DatabaseError.ExistNicknameError
    //            }
    //
    //            try await db.collection("Users").document(uid).setData(data.toJSON())
    //        } catch let err {
    //
    //            switch err {
    //            case is DatabaseError:
    //                throw DatabaseError.ExistNicknameError
    //            default:
    //                throw DatabaseError.UnknownError
    //            }
    //        }
    //    }
    //
    //
    //
    //
    ////        return Observable.create { [weak self] (observer) in
    ////
    ////            guard let strongSelf = self else { return }
    ////
    ////            let task = Task {
    ////
    ////                do {
    ////
    ////                    try await strongSelf.db.document("Users").setData(data.toJSON())
    ////
    ////                    observer.onNext(.success(true))
    ////                    observer.onCompleted()
    ////
    ////                } catch {
    ////
    ////                    observer.onNext(.failure(DatabaseError.UnknownError))
    ////                    observer.onCompleted()
    ////
    ////                }
    ////            }
    ////
    ////            return Disposables.create {
    ////                task.cancel()
    ////            }
    ////        }
    ////    }
    //
    ////    func createMapData(with userData: UserMap, completion: @escaping (Result<String, DatabaseError>) -> Void) {
    ////
    ////        let uid = UUID().uuidString
    ////
    ////        db.collection("Maps").document(uid).setData(userData.toDomain(uid: uid)) { error in
    ////
    ////            guard error == nil else {
    ////                print("Set Data Error")
    ////                completion(.failure(DatabaseError.FetchError))
    ////                return
    ////            }
    ////
    ////            print("Set Data success")
    ////            completion(.success(uid))
    ////            return
    ////        }
    ////
    ////    }
    //
    //    func createMapData(with userData: UserMap, uid: String, urls: [String]) {
    //
    //        db.collection("Maps").document(uid).setData(userData.toJSON(uid: uid, urls: urls)) { error in
    //
    //            guard error == nil else {
    //                print("Write Data Error")
    //                return
    //            }
    //
    //            return
    //        }
    //
    //    }
    //
    //    func uploadMapData(with userData: UserMap, uid: String, urls: [String]) async throws {
    //
    //        do {
    //            try await db.collection("Maps").document(uid).setData(userData.toJSON(uid: uid, urls: urls))
    //        } catch {
    //            throw DatabaseError.UnknownError
    //        }
    //    }
    //
    //    func uploadMapData2(with userData: UserMap, uid: String) async throws {
    //        do {
    //            try await db.collection("Maps").document(uid).setData(userData.toJSON2(uid: uid))
    //        } catch let err {
    //            print("uploadMapData2 err: \(err.localizedDescription)")
    //            throw DatabaseError.UnknownError
    //        }
    //    }
    //
    //    func fetchMapListData() -> Observable<[MapList]> {
    //
    //        return Observable.create { [weak self] (observer) in
    //
    //            self?.db.collection("Maps").getDocuments { snapshot, error in
    //
    //                guard let documents = snapshot?.documents else {
    //                    observer.onError(DatabaseError.DatabaseFetchError)
    //                    return
    //                }
    //
    //                var mapList: [MapList] = []
    //
    //                for document in documents {
    //                    let data = document.data()
    //
    //                    do {
    //                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
    //                        let decoded = try JSONDecoder().decode(MapList.self, from: jsonData)
    //                        mapList.append(decoded)
    //                    } catch let err {
    //                        print("Decode error: \(err)")
    //                    }
    //                }
    //
    //                observer.onNext(mapList)
    //                observer.onCompleted()
    //            }
    //            return Disposables.create()
    //        }
    //    }
    //
    //    func fetchMapListData2() async throws -> [MapList?] {
    //
    //        return try await withThrowingTaskGroup(of: MapList?.self) { group in
    //
    //            let snapshot = try await db.collection("Maps").getDocuments()
    //
    //            let documnets = snapshot.documents
    //
    //            for documnet in documnets {
    //
    //                let data = documnet.data()
    //
    //                group.addTask {
    //
    //                    do {
    //                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
    //                        return try JSONDecoder().decode(MapList.self, from: jsonData)
    //                    } catch let err {
    //                        print("err: \(err.localizedDescription)")
    //                        throw DatabaseError.UnknownError
    //                    }
    //                }
    //            }
    //
    //            return try await group
    //                .reduce(into: [MapList?](), { $0.append($1) })
    //                .compactMap { $0 }
    //        }
    //    }
    //
    //    func fetchMapListData3() async throws -> [MapList] {
    //
    //        return try await withThrowingTaskGroup(of: MapList.self) { group in
    //
    //            let snapshot = try await db.collection("Maps").getDocuments()
    //
    //            let documnets = snapshot.documents
    //
    //            for documnet in documnets {
    //
    //                let data = documnet.data()
    //
    //                group.addTask {
    //
    //                    do {
    //                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
    //                        return try JSONDecoder().decode(MapList.self, from: jsonData)
    //                    } catch let err {
    //                        print("err: \(err.localizedDescription)")
    //                        throw DatabaseError.UnknownError
    //                    }
    //                }
    //            }
    //
    //            return try await group
    //                .reduce(into: [MapList](), { $0.append($1) })
    //        }
    //    }
    //}
    //
    //
}
