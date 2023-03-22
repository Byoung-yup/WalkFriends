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
    
    func createUserProfile(with userProfile: UserProfile) -> Observable<Bool> {
        
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.db.collection("Users").document(UserInfo.shared.uid!).setData(userProfile.toDomain()) { err in
                
                guard err == nil else {
                    print("Set Data Error")
                    observer.onError(err!)
                    return
                }
                print("Set Data success")
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        })     
    }
    
}
