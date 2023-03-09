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
    
    var email: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail() }
    }
    
    var existsUser: Observable<Bool> {
        email.flatMap { FirebaseService.shard.userExists(with: $0) }
    }
}
