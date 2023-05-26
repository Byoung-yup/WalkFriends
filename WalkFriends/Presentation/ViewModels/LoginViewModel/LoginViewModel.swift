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

protocol LoginViewModelActionDelegate {
    func showRegisterVC()
    func signIn()
}

final class LoginViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
        let register: Observable<Void>
    }
    
    // MARK: - Output {
    
    struct Output {
        let present: Observable<Void>
        let loginEnabled: Driver<Bool>
        let loginTrigger: Observable<Result<Bool, FirebaseAuthError>>
    }
    
    // MARK: - Properties
    
    var actionDelegate: LoginViewModelActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
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
        
        let register = input.register
            .do(onNext: { [weak self] in
                self?.actionDelegate?.showRegisterVC()
            })
                
        return Output(present: register, loginEnabled: loginEnabled, loginTrigger: login)
    }
}
