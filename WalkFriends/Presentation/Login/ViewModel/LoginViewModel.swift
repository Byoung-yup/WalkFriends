//
//  LoginViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

struct LoginViewModelActions {
//    let showRegisterViewController: () -> Void
    let signIn: () -> Void
//    let showResetViewController: () -> Void
}

final class LoginViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
        let google_SignIn: Observable<Void>
        let facebook_SignIn: Observable<Void>
        let kakak_SignIn: Observable<Void>
    }
    
    // MARK: - Output {
    
    struct Output {
        let loginEnabled: Observable<Bool>
        let loginTrigger: Observable<Result<Bool, FirebaseAuthError>>
        let isLoginState: Observable<Bool>
        let signIn: Observable<Bool>
//        let loginTrigger_Google: Observable<Result<Bool, FirebaseAuthError>>
//        let loginTrigger_Facebook: Observable<Result<Bool, FirebaseAuthError>>
//        let loginTrigger_Kakao: Observable<Result<Bool, FirebaseAuthError>>
    }
    
    // MARK: - Properties
    
    let actions: LoginViewModelActions
    private let dataUseCase: DataUseCase
    let isLoginState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    // MARK: - Init
    init(actions: LoginViewModelActions, dataUseCase: DataUseCase) {
        self.actions = actions
        self.dataUseCase = dataUseCase
    }
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        
        let emailEnabled = input.email
            .map { $0.isValidEmail() }
        
        let psEnabled = input.password
            .map { $0.isValidPassword() }
        
        let loginEnabled = Observable.combineLatest(emailEnabled, psEnabled) { $0 && $1 }
        
        let userInfo = Observable.combineLatest(input.email, input.password)
            .map {
                return UserLoginInfo(email: $0, password: $1)
            }
        
        let login = input.login.withLatestFrom(userInfo)
            .flatMapLatest {
                return FirebaseService.shard.signIn2(with: $0) }
        
        let googleSignIn = input.google_SignIn
            .flatMap { return FirebaseService.shard.googleSignIn() }
        
        let fbSignIn = input.facebook_SignIn
            .flatMap { return FirebaseService.shard.fbSignIn() }
        
        let kakaoSignIn = input.kakak_SignIn
            .flatMap { return FirebaseService.shard.kakaoSignIn() }
        
        let login_merge = Observable.merge(googleSignIn, fbSignIn, kakaoSignIn)
        
        return Output(loginEnabled: loginEnabled,
                      loginTrigger: login_merge,
                      isLoginState: isLoginState.asObservable(),
                      signIn: login)
        
    }
}
