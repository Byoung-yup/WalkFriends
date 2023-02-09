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

final class LoginViewModel {
    
    let email: PublishSubject<String> = PublishSubject<String>()
    let password: PublishSubject<String> = PublishSubject<String>()
    
    var isVaildEmail: Observable<Bool> {
        email.map { $0.isValidEmail() }
    }
    
    var isVaildPassword: Observable<Bool> {
        password.map { $0.isValidPassword() }
    }
    
    var isValidInput: Observable<Bool> {
        Observable.combineLatest(isVaildEmail, isVaildPassword).map { $0 && $1 }
    }
}

extension LoginViewModel {
    
    func signIn(with email: String, password: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            FirebaseService.shard.signIn(with: email, password: password) { result in
                
                if result { observer.onNext(true) }
                else { observer.onNext(false) }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
}
