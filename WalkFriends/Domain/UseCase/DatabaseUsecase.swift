//
//  DatabaseUsecase.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/31.
//

import Foundation
import RxSwift

final class DatabaseUsecase {
    
    private let dataBaseRepository: DataRepository
    private let storageRepository: ImageRepository
    
    init(dataBaseRepository: DataRepository, storageRepository: ImageRepository) {
        self.dataBaseRepository = dataBaseRepository
        self.storageRepository = storageRepository
    }
}

extension DatabaseUsecase {
    
    // Create User
    func createUser(with data: UserProfileData) -> Observable<Result<Bool, FBError>> {
        print("createUser")
//        return Observable<Result<Bool, FBError>>.just(.success(true))
        return dataBaseRepository.createUser(with: data)
            .flatMap { [weak self] result in

                guard let self = self else { fatalError() }

                switch result {
                case .success(_):
                    return self.storageRepository.createUserProfile(with: data.imageData)
                case .failure(let err):
                    return Observable<Result<Bool, FBError>>.just(.failure(err))
                }
            }
    }
}
