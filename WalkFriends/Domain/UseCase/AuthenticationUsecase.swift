//
//  AuthenticationUsecase.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/31.
//

import Foundation
import RxSwift

final class AuthenticationUsecase {
    
    private let authRepository: AuthRepository
    private let dataBaseRepository: DataRepository
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(authRepository: AuthRepository, dataBaseRepository: DataRepository) {
        self.authRepository = authRepository
        self.dataBaseRepository = dataBaseRepository
    }
}

extension AuthenticationUsecase {
    
    // MARK: - Phone Authentication
    
    func verifyPhoneNumber(_ phoneNumber: String) -> Observable<Result<Bool, FirebaseError>> {
        
        return authRepository.verifyPhoneNumber(phoneNumber: phoneNumber)
    }
    
    func signIn(_ data: AuthCode) -> Observable<Result<Bool, FirebaseAuthError>> {
        
        return authRepository.signIn(phoneNumber: data.number, code: data.code)
            .flatMap { result in
                
                switch result {
                case .success(_):
                    return Observable<Result<Bool, FirebaseAuthError>>.just(.success(true))
                case .failure(let err):
                    return Observable<Result<Bool, FirebaseAuthError>>.just(.failure(err))
                }
            }
    }
}
