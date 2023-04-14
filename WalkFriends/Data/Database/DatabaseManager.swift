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
                //                do {
                //                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                //                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                //                    completion(.success(decoded))
                //                } catch {
                //                    print("Decode error")
                //                }
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
    
}
