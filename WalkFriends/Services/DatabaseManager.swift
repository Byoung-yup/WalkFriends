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
                    "email": "\(user.email)",
                    "favorite": []
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
