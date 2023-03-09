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
    
    let signInSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    
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
