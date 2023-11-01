//
//  FirebaseManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/31.
//

import FirebaseAuth
import RxSwift

enum FirebaseAuthError: Error {
    case AlreadyEmailError
    case InvalidEmailError
    case WeakPasswordError
    case UserNotFoundError
    case WrongPasswordError
    case AuthenticationError
    case NetworkError
    //
    case NotFoundVerifycation
    case InvalidCredential
    case UserDisabled
    case MissingVerificationID
    case InvalidVerificationID
    case SessionExpired
    case UnknownError
}

enum FirebaseError: Error {
    case CaptchaCheckFailed
    case QuotaExceeded
    case InvalidPhoneNumber
    case MissingPhoneNumber
}

final class FirebaseManager {
    
    var auth = {
        let auth = FirebaseAuth.Auth.auth()
        auth.languageCode = "kr"
        return auth
    }()
}

extension FirebaseManager: AuthRepository {
    
    func verifyPhoneNumber(phoneNumber: String) -> Observable<Result<Bool, FirebaseError>> {
        
        return Observable.create { (observer) in
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                
                guard error == nil else {
                    
                    let errorCode = AuthErrorCode.Code(rawValue: (error! as NSError).code)
                    switch errorCode {
                    case .captchaCheckFailed:
                        observer.onNext(.failure(FirebaseError.CaptchaCheckFailed))
                    case .quotaExceeded:
                        observer.onNext(.failure(FirebaseError.QuotaExceeded))
                    case .invalidPhoneNumber:
                        observer.onNext(.failure(FirebaseError.InvalidPhoneNumber))
                    case .missingPhoneNumber:
                        observer.onNext(.failure(FirebaseError.MissingPhoneNumber))
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
    
    func signIn(phoneNumber: String, code: String) -> Observable<Result<Bool, FirebaseAuthError>> {
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        return Observable.create { (observer) in
 
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                guard error == nil else {
                    
                    let errorCode = AuthErrorCode.Code(rawValue: (error! as NSError).code)
                    
                    switch errorCode {
                    case .invalidCredential:
                        observer.onNext(.failure(.InvalidCredential))
                    case .userDisabled:
                        observer.onNext(.failure(.UserDisabled))
                    case .missingVerificationID:
                        observer.onNext(.failure(.MissingVerificationID))
                    case .invalidVerificationID:
                        observer.onNext(.failure(.InvalidVerificationID))
                    case .sessionExpired:
                        observer.onNext(.failure(.SessionExpired))
                    default:
                        observer.onNext(.failure(.UnknownError))
                    }
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
                
            }
            return Disposables.create()
        }
    }
}
