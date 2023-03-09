//
//  MainViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
    func fetchMyProfileData()
}

protocol HomeViewModelOutput {
    
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

class DefaultHomeViewModel: HomeViewModel {

    private let fetchDataUseCase: FetchDataUseCase
    
    init(fetchDataUseCase: FetchDataUseCase) {
        self.fetchDataUseCase = fetchDataUseCase
    }
    
}

// MARK: - INPUT. View event methods

extension HomeViewModel {
    
    func fetchMyProfileData() {
        
    }
    
}
