//
//  FirebaseManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/31.
//

import FirebaseAuth
import RxSwift
import SwiftKeychainWrapper

//enum FirebaseAuthError: Error {
//    case AlreadyEmailError
//    case InvalidEmailError
//    case WeakPasswordError
//    case UserNotFoundError
//    case WrongPasswordError
//    case AuthenticationError
//    case NetworkError
//    //
//    case NotFoundVerifycation
//    case InvalidCredential
//    case UserDisabled
//    case MissingVerificationID
//    case InvalidVerificationID
//    case SessionExpired
//    case UnknownError
//}

enum FBError: Error {
    // Verifycation
    case CaptchaCheckFailed
    case QuotaExceeded
    case InvalidPhoneNumber
    case MissingPhoneNumber
    
    // Auth
    case NotFoundVerifycation
    case UserDisabled
    case SessionExpired
    
    // Database
    case NotFoundUserError
    case DatabaseFetchError
    case ExistNicknameError
    
    // Storage
    
    // ETC
    case UnknownError
}

//enum FirebaseError: Error {
//    case NotFoundVerifycation
//    case InvalidCredential
//    case UserDisabled
//    case MissingVerificationID
//    case InvalidVerificationID
//    case SessionExpired
//    case UnknownError
//}

final class FirebaseManager {
    
    var auth = {
        let auth = FirebaseAuth.Auth.auth()
        auth.languageCode = "kr"
        return auth
    }()
    
//    var handle: AuthStateDidChangeListenerHandle!
}

extension FirebaseManager: AuthRepository {
    
    func verifyPhoneNumber(phoneNumber: String) -> Observable<Result<Bool, FBError>> {
        
        return Observable.create { (observer) in
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                
                guard error == nil else {
                    
                    let errorCode = AuthErrorCode.Code(rawValue: (error! as NSError).code)
                    switch errorCode {
                    case .captchaCheckFailed:
                        observer.onNext(.failure(.CaptchaCheckFailed))
                    case .quotaExceeded:
                        observer.onNext(.failure(.QuotaExceeded))
                    case .invalidPhoneNumber:
                        observer.onNext(.failure(.InvalidPhoneNumber))
                    case .missingPhoneNumber:
                        observer.onNext(.failure(.MissingPhoneNumber))
                    default:
                        break
                    }
                    observer.onCompleted()
                    return
                }
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                
                observer.onNext(.success(true))
                observer.onCompleted()
                
            }
            return Disposables.create()
        }
    }
    
    func signIn(phoneNumber: String, code: String) -> Observable<Result<Bool, FBError>> {
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        return Observable.create { (observer) in
            
            let task = Task {
                
                do {
                    _ = try await Auth.auth().signIn(with: credential)
                    
                    Auth.auth().addStateDidChangeListener({ (auth, user) in
                        
                        if let currentUser = auth.currentUser {
//                            print("Listener Auth UID: \(currentUser.uid)")
//                            print("Listener Auth NUM: \(currentUser.phoneNumber)")
                            KeychainWrapper.standard.set("\(currentUser.uid)", forKey: "UID")
                            KeychainWrapper.standard.set("\(phoneNumber)", forKey: "PhoneNumber")
                            
                            observer.onNext(.success(true))
                            observer.onCompleted()
                        }
                        
//                        print("Listener Auth: \(auth)")
//                        print("Listener Auth UID: \(auth.currentUser?.uid)")
//                        print("Listener Auth NUM: \(auth.currentUser?.phoneNumber)")
//                        print("Listener User: \(user)")
//                        print("Listener User UID: \(user?.providerData[0].uid)")
                        
                        
                    })
                } catch let err as NSError {
                    let errorCode = AuthErrorCode.Code(rawValue: err.code)
                    
                    switch errorCode {
                    case .userDisabled:
                        observer.onNext(.failure(.UserDisabled))
                    case .sessionExpired:
                        observer.onNext(.failure(.SessionExpired))
                    default:
                        observer.onNext(.failure(.UnknownError))
                    }
                    observer.onCompleted()
                }
            }
 
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//
//                guard error == nil else {
//
//
//                    observer.onCompleted()
//                    return
//                }
//
//                observer.onNext(.success(phoneNumber))
//                observer.onCompleted()
//
//            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
