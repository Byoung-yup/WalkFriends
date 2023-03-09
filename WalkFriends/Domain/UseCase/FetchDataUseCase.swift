//
//  DefaultUseCase.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/03.
//

import Foundation
import UIKit
import RxSwift

protocol FetchDataUseCase {
    func excuteProfile()
}

class DefaultFetchDataUseCase: FetchDataUseCase {
    
    private let dataBaseRepository: UserProfileRepository
    
    init(dataBaseRepository: UserProfileRepository) {
        self.dataBaseRepository = dataBaseRepository
    }
    
    func excuteProfile() {
        
    }
}
