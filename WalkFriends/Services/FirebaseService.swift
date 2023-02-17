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
import RxSwift

protocol FirebaseAuthService {
    func userExists(with email: String) -> Observable<Bool>
}

final class FirebaseService {
    
    static let shard = FirebaseService()
    
    private let auth = FirebaseAuth.Auth.auth()
    
}

enum FirebaseAuthError: Error {
    case userExistsError
}

extension FirebaseService: FirebaseAuthService {
    
    // MARK: exists user
    func userExists(with email: String) -> Observable<Bool> {
        print("userExists")
        return Observable.create { (observer) -> Disposable in
            print("create")
            self.auth.fetchSignInMethods(forEmail: email) { emailList, _ in
                print("fetchSignIn")
                if emailList != nil {
                    // 존재함
                    observer.onNext(true)
//                    print("존재함")
                } else {
                    // 존재하지 않음
                    observer.onNext(false)
//                    print("존재하지 않음")
                }
                observer.onCompleted()
//                print("observer: \(observer)")
            }
            
            return Disposables.create()
        }
    }
        
//    func userExists(with email: String, completion: @escaping (Bool) -> Void) {
//
//        auth.fetchSignInMethods(forEmail: email) { emailList, _ in
//
//            guard emailList == nil else {
//                // 존재함
//                print("존재함")
//                completion(false)
//                return
//            }
//
//            // 존재하지 않음
//            print("존재하지 않음")
//            completion(true)
//            return
//        }
//    }
        
    // MARK: create User
    func createUser(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            
            guard authResult != nil, error == nil else {
                if let error = error?.localizedDescription {
                    print("error: \(error)")
                }
                completion(false)
                return
            }
            
            completion(true)
            return
        }
        
    }
    
    // MARK: signIn
    func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
//            guard let strongSelf = self else { return }
            
            guard authResult != nil, error == nil else {
                print("error: \(error?.localizedDescription)")
                completion(false)
                return
            }
            
//            if let user = strongSelf.auth.currentUser {
//                let currentUser = User(uid: user.uid, email: user.email!)
//
//                DatabaseManager.shared.insertUsers(with: currentUser) { result in
//
//                    if result {
//                        completion(true)
//                        return
//                    }
//                    else {
//                        completion(false)
//                        return
//                    }
//                }
//            }
            completion(true)
        }
        
    }
    
    // MARK: logout
    func logout(completion: @escaping (Bool) -> Void) {
        
        do {
            try auth.signOut()
            completion(true)
        } catch let error {
            print("logout error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
