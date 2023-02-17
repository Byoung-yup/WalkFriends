//
//  DatabaseManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol DatabaseService {
    func insertUsers(with user: User, completion: @escaping (Bool) -> Void)
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()

}

extension DatabaseManager: DatabaseService {
    
    // MARK: check User Profile
    func checkUserProfile(with uid: String, completion: @escaping (Bool) -> Void) {
        
        
    }
    
    // MARK: create Users
    func insertUsers(with user: User, completion: @escaping (Bool) -> Void) {
        
        let docRef = database.collection("user").document(user.uid)
        
        docRef.getDocument { [weak self] document, error in
            guard let strongSelf = self else { return }
            
            if let document = document, document.exists {
                print("user exists")
                completion(true)
                return
            } else {
                
                strongSelf.database.collection("user").document(user.uid).setData([
                    "email": user.email,
                    "favorite": [],
                    "nickname": "",
                    "liking": [
                        "up": 0,
                        "down": 0
                    ],
                    "pet": [
                        "name": "",
                        "age": 0,
                        "gender": ""
                    ]
                ]) { error in
                    guard error == nil else {
                        print("Failed to write Database")
                        completion(false)
                        return
                    }
                }
                
                print("Set user data")
                completion(true)
                return
                
            }
        }
    }
    
    // MARK: check User Profile
    func loadUserProfile(user uid: String, completion: @escaping (UserProfile?) -> Void) {
        
        let docRef = database.collection("user").document(uid)
        
        docRef.getDocument { document, _ in
            if let document = document, document.exists {
                print("documnet exists")
                do {
                    if let documentDecription = document.data() {
                        let jsonData = try JSONSerialization.data(withJSONObject: documentDecription)
                        let userProfile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                        
                        completion(userProfile)
                        print("document: \(userProfile)")
                        return
                    }
                } catch let error {
                    print("UserProfile dose not decode: \(error.localizedDescription)")
                }
                
            } else {
                print("documnet dose not exists")
                completion(nil)
                return
                
            }
        }
    }
}
