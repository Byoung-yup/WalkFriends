//
//  FirebaseService.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/08.
//

import Foundation
import FirebaseAuth
import UIKit
import RxSwift

protocol FirebaseAuthService {
    func createUser(user: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>>
    func signIn(with userInfo: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>>
}

final class FirebaseService {

    static let shard = FirebaseService()

    var auth: Auth = {
        let auth = FirebaseAuth.Auth.auth()
        auth.useAppLanguage()
        return auth
    }()
    
    var currentUser: User {
        guard let currentUser = auth.currentUser else {
            fatalError("Not Found Current User")
        }
        return currentUser
    }
    
    var UserProfle: UserProfile?
    
    private init() {}

}

enum FirebaseAuthError: Error {
    case AlreadyEmailError
    case InvalidEmailError
    case WeakPasswordError
    case UserNotFoundError
    case WrongPasswordError
    case AuthenticationError
    case NetworkError
}


extension FirebaseService: FirebaseAuthService {

    // MARK: Create User
    
    func createUser(user: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>> {

        return Observable.create {  (observer) in
            
            let task = Task { [weak self] in
                do {
                    
                    guard let strongSelf = self else { return }
                    
                    let result = try await strongSelf.auth.createUser(withEmail: user.email, password: user.password)
                    try await result.user.sendEmailVerification()
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    
                } catch let err as NSError {
                    let errorCode = AuthErrorCode.Code(rawValue: err.code)
                    
                    switch errorCode {
                    case .emailAlreadyInUse:
                        observer.onNext(.failure(FirebaseAuthError.AlreadyEmailError))
                        observer.onCompleted()
                    case .invalidEmail:
                        observer.onNext(.failure(FirebaseAuthError.InvalidEmailError))
                        observer.onCompleted()
                    case .weakPassword:
                        observer.onNext(.failure(FirebaseAuthError.WeakPasswordError))
                        observer.onCompleted()
                    default:
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }

    // MARK: signIn

    func signIn(with userInfo: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>> {
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                do {
                    
                    guard let strongSelf = self else { return }
                    
                    let authResult = try await strongSelf.auth.signIn(withEmail: userInfo.email, password: userInfo.password)
                    guard authResult.user.isEmailVerified else {
                        
                        try FirebaseAuth.Auth.auth().signOut()
                        observer.onNext(.failure(FirebaseAuthError.AuthenticationError))
                        observer.onCompleted()
                        return
                        
                    }
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    
                } catch let err as NSError {
                    let errorCode = AuthErrorCode.Code(rawValue: err.code)
                    
                    switch errorCode {
                    case .wrongPassword:
                        observer.onNext(.failure(FirebaseAuthError.WrongPasswordError))
                        observer.onCompleted()
                    case .userNotFound:
                        observer.onNext(.failure(FirebaseAuthError.UserNotFoundError))
                        observer.onCompleted()
                    default:
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                        observer.onCompleted()
                    }
                }
            }
        
            return Disposables.create {
                task.cancel()
            }
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
