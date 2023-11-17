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

    func verifyPhoneNumber(_ phoneNumber: String) -> Observable<Result<Bool, FBError>> {

        return authRepository.verifyPhoneNumber(phoneNumber: phoneNumber)
    }

    func signIn(_ data: AuthCode) -> Observable<Result<Bool, FBError>> {
//        return Observable<Result<Bool, FBError>>.just(.success(false))
//        return Observable<Result<Bool, FBError>>.just(.failure(.SessionExpired))
        return authRepository.signIn(phoneNumber: data.number, code: data.code)
            .flatMap { [weak self] result in

                    guard let self = self else { fatalError() }

                    switch result {
                    case .success(_):
                        return self.dataBaseRepository.checkUser()
                    case .failure(let err):
                        return Observable<Result<Bool, FBError>>.just(.failure(err))
                    }

            }
    }
}
