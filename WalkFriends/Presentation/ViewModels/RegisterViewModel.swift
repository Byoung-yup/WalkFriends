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

final class RegiterViewModel {
    
    let email: PublishSubject<String> = PublishSubject<String>()
    let password: PublishSubject<String> = PublishSubject<String>()
    let confirmPassword: PublishSubject<String> = PublishSubject<String>()
    
    var isValidPassword: Observable<Bool> {
        password.map { !$0.isValidPassword() }
    }
    
    var passwordObservable: Observable<String> {
        password.asObserver()
    }
    
    var confirmPasswordObservable: Observable<String> {
        confirmPassword.asObserver()
    }
    
    var isEuqalPassword: Observable<Bool> {
        Observable.combineLatest(passwordObservable, confirmPasswordObservable).map { $0 != $1 }
    }
    
    var isValidRegister: Observable<Bool> {
        Observable.combineLatest(isValidPassword, isEuqalPassword).map { !$0 && !$1 }
    }
    
//    var isValidRegister: Observable<Bool> {
//        Observable.combineLatest(isValidEmail, passwordWithConfirmPassword).map { !$0 && $1 }
//    }
//    
//    var register: Observable<Bool> {
//        Observable.flatMap { FirebaseService.shard.createUser(with: User(email: email, password: password)) }
//    }
}

// MARK: Firebase Auth Service
//extension RegiterViewModel {
//
//    func createUsers(with email: String, password: String) -> Observable<Bool> {
//
//        return Observable.create { observer in
//
//            FirebaseService.shard.createUser(with: email, password: password) { result in
//
//                if result { observer.onNext(true) }
//                else { observer.onNext(false)}
//
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
//}
