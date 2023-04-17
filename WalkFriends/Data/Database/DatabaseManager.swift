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
    case FetchError
}

final class DatabaseManager {
    
    private let db = Firestore.firestore()
    
}

// MARK: - UserProfileRepository

extension DatabaseManager: DataRepository {
    
    func fetchUserProfile(completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
        print("fetchUserProfile")
        db.collection("Users").document(FirebaseService.shard.currentUser.uid).getDocument { document, error in
            
            if let document = document, document.exists {
                let data = document.data()
                print("data exists")
                completion(.success(true))
//                                do {
//                                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
//                                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
//                                    completion(.success(decoded))
//                                } catch {
//                                    print("Decode error")
//                                }
            } else {
                print("Data fetch error")
                completion(.failure(DatabaseError.FetchError))
            }
            return
        }
        
    }
    
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
    
    func createMapData(with userData: UserMap, completion: @escaping (String) -> Void) {
        
        let uid = UUID().uuidString

        db.collection("Maps").document(uid).setData(userData.toDomain(uid: uid)) { error in
            
            guard error == nil else {
                print("Set Data Error")
                return
            }
            
            print("Set Data success")
            completion(uid)
            return
        }
        
    }
    
    func fetchMapListData(completion: @escaping (Result<[MapList], DatabaseError>) -> Void) {
        
        db.collection("Maps").getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {
                completion(.failure(DatabaseError.FetchError))
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
            
            completion(.success(mapList))
        }
    }
    
}
