//
//  FirebaseService.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/08.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import UIKit

final class FirebaseService {
    
    static let shard = FirebaseService()
    
    private let auth = FirebaseAuth.Auth.auth()
    
}

extension FirebaseService {
    
    // MARK: create User
    func createUser(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            
            guard authResult != nil, error == nil else {
                print("Error creating user")
                completion(false)
                return
            }
            
            completion(true)
            return
        }
        
    }
    
    // MARK: signIn
    func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            guard authResult != nil, error == nil else {
                print("error: \(error?.localizedDescription)")
                completion(false)
                return
            }
            
            if let user = strongSelf.auth.currentUser {
                let currentUser = User(uid: user.uid, email: user.email!)
                
                DatabaseManager.shared.insertUsers(with: currentUser) { result in
                    
                    if result {
                        completion(true)
                        return
                    }
                    else {
                        completion(false)
                        return
                    }
                }
            }
            
        }
        
    }
}
