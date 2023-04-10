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

struct UserLoginInfo {
    let email: String
    let password: String
}

final class LoginViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let login: Driver<Void>
        let register: Driver<Void>
    }
    
    // MARK: - Output {
    
    struct Output {
        let present: Driver<Void>
        let loginEnabled: Driver<Bool>
        let loginTrigger: Driver<Bool>
    }
    
    // MARK: - Properties
    
    var actionDelegate: LoginViewModelActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let emailEnabled = input.email
            .map { $0.isValidEmail() }
        
        let psEnabled = input.password
            .map { $0.isValidPassword() }
        
        let loginEnabled = Driver.combineLatest(emailEnabled, psEnabled) { $0 == $1 }
        
        let userInfo = Driver.combineLatest(input.email, input.password)
            .map {
                return UserLoginInfo(email: $0, password: $1)
            }
        
        let login = input.login.withLatestFrom(userInfo)
            .flatMapLatest {
                return FirebaseService.shard.signIn(with: $0)
                    .asDriver(onErrorJustReturn: false)
            }.do(onNext: { [weak self] result in
                if result { self?.actionDelegate?.signIn() }
            })
        
        let register = input.register
            .do(onNext: { [weak self] in
                self?.actionDelegate?.showRegisterVC()
            })
                
        return Output(present: register, loginEnabled: loginEnabled, loginTrigger: login)
    }
}
