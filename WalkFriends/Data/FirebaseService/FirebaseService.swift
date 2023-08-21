//
//  FirebaseService.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/08.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import UIKit
import RxSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit_Basics
import KakaoSDKAuth
import KakaoSDKUser

protocol FirebaseAuthService {}

protocol DefaultService: FirebaseAuthService {
    func createUser(user: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>>
    func signIn(with userInfo: UserLoginInfo) -> Observable<Result<Bool, FirebaseAuthError>>
    func logout() -> Observable<Result<Bool, FirebaseAuthError>>
}

protocol GoogleService: FirebaseAuthService {
    func googleSignIn() -> Observable<Result<Bool, FirebaseAuthError>>
}

protocol FacebookService: FirebaseAuthService {
    func fbSignIn() -> Observable<Result<Bool, FirebaseAuthError>>
}

protocol KakaoService: FirebaseAuthService {
    func kakaoSignIn() -> Observable<Result<Bool, FirebaseAuthError>>
}

final class FirebaseService {
    
    static let shard = FirebaseService()
    
    var auth = {
        let auth = FirebaseAuth.Auth.auth()
        return auth
    }()

    var currentUser: UserInfo?
//    var handle: AuthStateDidChangeListenerHandle!
//
//    var UserProfle: UserProfile?
    
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
        
        return Observable.create { (observer) in
            
            let task = Task {
                
                do {
                    let result = try await FirebaseAuth.Auth.auth().createUser(withEmail: user.email, password: user.password)
                    try await result.user.sendEmailVerification()
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    
                } catch let err as NSError {
                    let errorCode = AuthErrorCode.Code(rawValue: err.code)
                    
                    switch errorCode {
                    case .emailAlreadyInUse:
                        observer.onNext(.failure(FirebaseAuthError.AlreadyEmailError))
                    case .invalidEmail:
                        observer.onNext(.failure(FirebaseAuthError.InvalidEmailError))
                    case .weakPassword:
                        observer.onNext(.failure(FirebaseAuthError.WeakPasswordError))
                    default:
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                    }
                    observer.onCompleted()
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
            
            let task = Task {
                do {
                    
                    let authResult = try await FirebaseAuth.Auth.auth().signIn(withEmail: userInfo.email, password: userInfo.password)
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
    
    func logout() -> Observable<Result<Bool, FirebaseAuthError>> {
        
        return Observable.create { (observer) in
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                observer.onNext(.success(true))
                observer.onCompleted()
            } catch let error {
                print("logout error: \(error.localizedDescription)")
                observer.onNext(.failure(FirebaseAuthError.NetworkError))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        
    }
}

// MARK: - GoogleService

extension FirebaseService {
    
    
    func googleSignIn() -> Observable<Result<Bool, FirebaseAuthError>> {
        print("Thread1: \(Thread.current)")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { fatalError() }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { fatalError() }
        
        return Observable.create { (observer) in
            print("Thread2: \(Thread.current)")
            let task = Task.detached { @MainActor in
                print("Thread3: \(Thread.current)")
                do {
                    
                    guard let clientID = FirebaseApp.app()?.options.clientID else { fatalError() }
                    
                    let config = GIDConfiguration(clientID: clientID)
                    GIDSignIn.sharedInstance.configuration = config
                    
                    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                    
                    let user = result.user
                    guard let idToken = user.idToken?.tokenString else {
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                        observer.onCompleted()
                        return
                    }
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                    print("token: \(credential)")
                    try await FirebaseAuth.Auth.auth().signIn(with: credential)
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                } catch {
                    observer.onNext(.failure(FirebaseAuthError.NetworkError))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: - FacebookService

extension FirebaseService {
    
    func fbSignIn() -> Observable<Result<Bool, FirebaseAuthError>> {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { fatalError() }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { fatalError() }
        
        let loginManager = LoginManager()
        
        return Observable.create { [weak self] (observer) in
            //            guard let strongSelf = self else { return }
            if let token = AccessToken.current, !token.isExpired  {
                print("token: \(token.tokenString)")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                self?.auth.signIn(with: credential) { (_, error) in
                    
                    guard error == nil else {
                        print("error2: \(error?.localizedDescription)")
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                        observer.onCompleted()
                        return
                    }
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    
                }
            } else {
                
                loginManager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { (result, error) in
                    
                    //                    guard let strongSelf = self else { return }
                    
                    guard error == nil, !(result!.isCancelled) else {
                        print("error1: \(error?.localizedDescription)")
                        observer.onNext(.failure(FirebaseAuthError.NetworkError))
                        observer.onCompleted()
                        return
                    }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                          
                    self?.auth.signIn(with: credential) { (user, error) in
                        
                        guard error == nil else {
                            print("error2: \(error?.localizedDescription)")
                            observer.onNext(.failure(FirebaseAuthError.NetworkError))
                            observer.onCompleted()
                            return
                        }
                            
                        observer.onNext(.success(true))
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}

// MARK: - KakaoService

extension FirebaseService {
    
    func kakaoSignIn() -> Observable<Result<Bool, FirebaseAuthError>> {
        
        return Observable.create { [weak self] (observer) in
                
                if AuthApi.hasToken() {
                    print("hasToken")
                    UserApi.shared.accessTokenInfo { (_, error) in
                        
                        if error != nil { // 유효하지 않은 토큰
                            print("유효하지 않은 토큰")
                            self?.openKakaoService()
                        }
                        else { // 유효한 토큰
                            print("유효한 토큰")
                            self?.loadingInfoDidKakaoAuth()
                        }
                    }
                }
                else { // 만료된 토큰
                    print("만료된 토큰")
                    self?.openKakaoService()
                }
            print("onNext")
            observer.onNext(.success(true))
            observer.onCompleted()
                
            return Disposables.create()
        }
    }
    
    func openKakaoService() {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in // 카카오톡 앱으로 로그인
                print("카카오 앱 로그인")
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                
                _ = oauthToken // 로그인 성공
                self?.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in // 카카오 웹으로 로그인
                print("카카오 웹 로그인")
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                _ = oauthToken // 로그인 성공
                self?.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                print("Kakao load user data: ", error.localizedDescription)
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let password = kakaoUser?.id else { return }
            
            print("email: \(kakaoUser?.kakaoAccount?.email)")
            print("id: \(kakaoUser?.id)")
            
            FirebaseAuth.Auth.auth().createUser(withEmail: "kakao_" + email, password: "\(password)") { (result, error) in
                
                if error != nil {
                    print("Error create account", error?.localizedDescription)
                }
                
                FirebaseAuth.Auth.auth().signIn(withEmail: "kakao_" + email, password: "\(password)") { (result, error) in
                    
                    guard error == nil else {
                        print("Error SignIn", error?.localizedDescription)
                        return
                    }
                }
            }
        }
    }
}
