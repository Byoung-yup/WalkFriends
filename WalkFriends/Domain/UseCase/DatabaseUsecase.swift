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
