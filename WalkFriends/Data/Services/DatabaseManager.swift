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

extension DatabaseManager: UserProfileRepository {
    
    func fetchUserProfile(completion: @escaping (Result<UserProfile, DatabaseError>) -> Void) {
        print("fetchUserProfile")
        db.collection("Users").document(UserInfo.shared.uid!).getDocument { document, error in
            
            if let document = document, document.exists {
                let data = document.data()
                print("data exists")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let decoded = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                    completion(.success(decoded))
                } catch {
                    print("Decode error")
                }
            } else {
                print("Data fetch error")
                completion(.failure(DatabaseError.FetchError))
            }
        }
            
    }
    
}
