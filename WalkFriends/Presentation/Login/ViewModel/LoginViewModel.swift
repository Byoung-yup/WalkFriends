//
//  LoginViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxSwift

struct LoginViewModelActions {
    //    let showRegisterViewController: () -> Void
    let dismiss: (Bool?) -> Void
    //    let showResetViewController: () -> Void
}

struct AuthCode {
    let number: String
    let code: String
}

final class LoginViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let phoneNumber: Observable<String>
        let authenticationNumber: Observable<String>
        let certification_Trigger: Observable<Void>
        let start_Trigger: Observable<Void>
        let toBack_Trigger: Observable<Void>
        //        let email: Observable<String>
        //        let password: Observable<String>
        //        let login: Observable<Void>
        //        let google_SignIn: Observable<Void>
        //        let facebook_SignIn: Observable<Void>
        //        let kakak_SignIn: Observable<Void>
    }
    
    // MARK: - Output {
    
    struct Output {
        let certification: Observable<Result<Bool, FBError>>
        let toBack: Observable<Void>
        let start: Observable<Result<Bool, FBError>>
        //        let loginEnabled: Observable<Bool>
        //        let loginTrigger: Observable<Result<Bool, FirebaseAuthError>>
        //        let isLoginState: Observable<Bool>
        //        let signIn: Observable<Bool>
        //        let loginTrigger_Google: Observable<Result<Bool, FirebaseAuthError>>
        //        let loginTrigger_Facebook: Observable<Result<Bool, FirebaseAuthError>>
        //        let loginTrigger_Kakao: Observable<Result<Bool, FirebaseAuthError>>
    }
    
    // MARK: - Properties
    
    let actions: LoginViewModelActions
    private let authUseCase: AuthenticationUsecase
    let isLoading: PublishSubject<Bool> = PublishSubject()
    
    // MARK: - Init
    init(actions: LoginViewModelActions, authUseCase: AuthenticationUsecase) {
        self.actions = actions
        self.authUseCase = authUseCase
    }
    
    deinit {
        print("LoginViewModel - deinit")
    }
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let toBack_Trigger = input.toBack_Trigger
        
        
        let certification = input.certification_Trigger.withLatestFrom(input.phoneNumber)
            .flatMapLatest { [weak self] in
                guard let self = self else { fatalError() }
//                print("num \($0)")
                return self.authUseCase.verifyPhoneNumber("+82 \($0)")
            }
        
        let code = Observable.combineLatest(input.phoneNumber, input.authenticationNumber) {
            return AuthCode(number: $0, code: $1)
        }
        
        let start_Trigger = input.start_Trigger.withLatestFrom(code)
            .flatMapLatest { [weak self] in
                guard let self = self else { fatalError() }
                self.isLoading.onNext(true)
                return self.authUseCase.signIn($0)
            }
        
        
        //        let emailEnabled = input.email
        //            .map { $0.isValidEmail() }
        //
        //        let psEnabled = input.password
        //            .map { $0.isValidPassword() }
        //
        //        let loginEnabled = Observable.combineLatest(emailEnabled, psEnabled) { $0 && $1 }
        //
        //        let userInfo = Observable.combineLatest(input.email, input.password)
        //            .map {
        //                return UserLoginInfo(email: $0, password: $1)
        //            }
        //
        //        let login = input.login.withLatestFrom(userInfo)
        //            .flatMapLatest {
        //                return FirebaseService.shard.signIn2(with: $0) }
        //
        //        let googleSignIn = input.google_SignIn
        //            .flatMap { return FirebaseService.shard.googleSignIn() }
        //
        //        let fbSignIn = input.facebook_SignIn
        //            .flatMap { return FirebaseService.shard.fbSignIn() }
        //
        //        let kakaoSignIn = input.kakak_SignIn
        //            .flatMap { return FirebaseService.shard.kakaoSignIn() }
        //
        //        let login_merge = Observable.merge(googleSignIn, fbSignIn, kakaoSignIn)
        
        return Output(certification: certification,
                      toBack: toBack_Trigger,
                      start: start_Trigger)
        
    }
}
