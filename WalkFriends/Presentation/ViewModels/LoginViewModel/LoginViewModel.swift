//
//  LoginViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct LoginViewModelActions {
    let showRegisterViewController: () -> Void
    let signIn: () -> Void
}


final class LoginViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
        let register: Observable<Void>
        let google_SignIn: Observable<Void>
        let facebook_SignIn: Observable<Void>
        let kakak_SignIn: Observable<Void>
    }
    
    // MARK: - Output {
    
    struct Output {
        let present: Observable<Void>
        let loginEnabled: Driver<Bool>
        let loginTrigger: Observable<Result<Bool, FirebaseAuthError>>
        let loginTrigger_Google: Observable<Result<Bool, FirebaseAuthError>>
        let loginTrigger_Facebook: Observable<Result<Bool, FirebaseAuthError>>
        let loginTrigger_Kakao: Observable<Result<Bool, FirebaseAuthError>>
    }
    
    // MARK: - Properties
    
    private let actions: LoginViewModelActions
//    var actionDelegate: LoginViewModelActionDelegate?
    
    // MARK: - Init
    init(actions: LoginViewModelActions) {
        self.actions = actions
    }
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { fatalError() }
//        guard let rootViewController = windowScene.windows.first?.rootViewController else { fatalError() }
        
        let emailEnabled = input.email
            .map { $0.isValidEmail() }
        
        let psEnabled = input.password
            .map { $0.isValidPassword() }
        
        let loginEnabled = Observable.combineLatest(emailEnabled, psEnabled) { $0 && $1 }.asDriver(onErrorJustReturn: false)
        
        let userInfo = Observable.combineLatest(input.email, input.password)
            .map {
                return UserLoginInfo(email: $0, password: $1)
            }
        
        let login = input.login.withLatestFrom(userInfo)
            .flatMapLatest {
                return FirebaseService.shard.signIn(with: $0)
            }
        
        let googleSignIn = input.google_SignIn
            .flatMap { return FirebaseService.shard.googleSignIn() }
        
        let fbSignIn = input.facebook_SignIn
            .flatMap { return FirebaseService.shard.fbSignIn() }
        
        let kakaoSignIn = input.kakak_SignIn
            .flatMap { return FirebaseService.shard.kakaoSignIn() }
        
        let register = input.register
            .do(onNext: { [weak self] in
                self?.actions.showRegisterViewController()
            })
                
        return Output(present: register, loginEnabled: loginEnabled, loginTrigger: login, loginTrigger_Google: googleSignIn, loginTrigger_Facebook: fbSignIn, loginTrigger_Kakao: kakaoSignIn)
    }
}
