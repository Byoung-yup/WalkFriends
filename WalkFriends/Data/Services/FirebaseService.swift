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
    func createUser(with user: User) -> Observable<Bool>
    func signIn(with email: String, password: String) -> Observable<Bool>
}

final class FirebaseService {

    static let shard = FirebaseService()

    private let auth = FirebaseAuth.Auth.auth()
    
    private init() {}

}

enum FirebaseAuthError: Error {
    case userExistsError
}

extension FirebaseService: FirebaseAuthService {

    // MARK: exists user
    func userExists(with email: String) -> Observable<Bool> {

        return Observable.create { [weak self] (observer) -> Disposable in

            self?.auth.fetchSignInMethods(forEmail: email) { emailList, _ in

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

    // MARK: Create User
    func createUser(with user: User) -> Observable<Bool> {

        return Observable.create { [weak self] (observer) -> Disposable in

            self?.auth.createUser(withEmail: user.email, password: user.password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    // 계정 생성 실패
                    observer.onNext(false)
                    return
                }

                // 계정 생성 완료
                observer.onNext(true)
                return
            }
            return Disposables.create()
        }
    }

    // MARK: signIn
    func signIn(with email: String, password: String) -> Observable<Bool> {

        return Observable.create { [weak self] (observer) -> Disposable in
            
            self?.auth.signIn(withEmail: email, password: password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    observer.onNext(false)
                    return
                }
                
                observer.onNext(true)
            }
            return Disposables.create()
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
