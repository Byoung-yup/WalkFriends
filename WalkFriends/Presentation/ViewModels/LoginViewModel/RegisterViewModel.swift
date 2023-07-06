//
//  RegisterViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import UIKit
import RxCocoa
import RxSwift

protocol RegisterViewModelActionDelegate {
    func toBack()
}

final class RegiterViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let register: Observable<Void>
//        let naviback: Observable<Void>
        let toBack: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let isValidEmail: Driver<Bool>
        let isValidPassword: Driver<Bool>
        let isValidConfirmPassword: Driver<Bool>
        let isValidRegister: Driver<Bool>
        let dismiss: Observable<Void>
        let registerTrigger: Observable<Result<Bool, FirebaseAuthError>>
    }
    
    // MARK: - Properties
    
    var actionDelegate: RegisterViewModelActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let checkEmail = input.email.map { $0.isValidEmail() }.asDriver(onErrorJustReturn: false)
        
        let checkPassword = input.password.map { $0.isValidPassword() }.asDriver(onErrorJustReturn: false)
        
        let checkConfirmPassword = Observable.combineLatest(input.password, input.confirmPassword) { $0 == $1  && $1.count > 0 }.asDriver(onErrorJustReturn: false)
        
        let checkRegister = Driver.combineLatest(checkEmail, checkPassword, checkConfirmPassword) { $0 && $1 && $2 }
        
        
        let user = Observable.combineLatest(input.email, input.password) { UserLoginInfo(email: $0, password: $1) }
        
        let register = input.register.withLatestFrom(user)
            .flatMapLatest {
                return FirebaseService.shard.createUser(user: $0)
            }
        //
        
        
        let dismiss = input.toBack
            .do(onNext: { [weak self] in
                self?.actionDelegate?.toBack()
            })
                
                return Output(isValidEmail: checkEmail,
                              isValidPassword: checkPassword,
                              isValidConfirmPassword: checkConfirmPassword,
                              isValidRegister: checkRegister,
                              dismiss: dismiss,
                              registerTrigger: register)
    }
    
}
