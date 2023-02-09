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
    func userExists(with email: String, completion: @escaping (Bool) -> Void)
    func insertUsers(with user: User, completion: @escaping (Bool) -> Void)
}

final class DatabaseManager: DatabaseService {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {
    
    // MARK: userExists Method
    func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        
        let docRef = database.collection("duplicate").document("email")
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
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
                    "email": "\(user.email)"
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
}
