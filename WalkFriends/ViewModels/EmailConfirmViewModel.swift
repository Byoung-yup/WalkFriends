//
//  EmailConfirmViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class EmailConfirmViewModel {
    
    var email: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail() }
    }
    
    // MARK: UserExists
    func userExists(with email: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.userExists(with: safeEmail) { result in
                
                if result {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
                
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
