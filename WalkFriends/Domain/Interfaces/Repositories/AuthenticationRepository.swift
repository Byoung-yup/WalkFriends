//
//  AuthenticationRepository.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/31.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func verifyPhoneNumber(phoneNumber: String) -> Observable<Result<Bool, FBError>>
    func signIn(phoneNumber: String, code: String) -> Observable<Result<Bool, FBError>>
}
