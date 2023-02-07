//
//  RegisterViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class RegiterViewModel {
    
    let name: PublishSubject<String> = PublishSubject<String>()
    let email: PublishSubject<Bool> = PublishSubject<Bool>()
    let password: PublishSubject<String> = PublishSubject<String>()
    let confirmPassword: PublishSubject<String> = PublishSubject<String>()
    
    var isValidName: Observable<Bool> {
        name.map { !$0.isValidName() }
    }
    
    var isValidEmail: Observable<Bool> {
        email.map { !$0 }
    }
    
    var isValidPassword: Observable<Bool> {
        password.map { !$0.isValidPassword() }
    }
    
    var passwordObservable: Observable<String> {
        password.asObserver()
    }
    
    var confirmPasswordObservable: Observable<String> {
        confirmPassword.asObserver()
    }
    
    var isValidConfirmPassword: Observable<Bool> {
        Observable.combineLatest(passwordObservable, confirmPasswordObservable).map { $0 != $1 }
    }
    
    var nameWithEmail: Observable<Bool> {
        Observable.combineLatest(isValidName, isValidEmail).map { !$0 && !$1 }
    }
    
    var passwordWithConfirmPassword: Observable<Bool> {
        Observable.combineLatest(isValidPassword, isValidConfirmPassword).map { !$0 && !$1 }
    }
    
    var isValidRegister: Observable<Bool> {
        Observable.combineLatest(nameWithEmail, passwordWithConfirmPassword).map { $0 && $1 }
    }
}
