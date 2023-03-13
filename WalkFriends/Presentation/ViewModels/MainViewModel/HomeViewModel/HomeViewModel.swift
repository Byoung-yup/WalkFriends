//
//  MainViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelActionDelegate {
    func setupProfile()
}

protocol HomeViewModelInput {
    func fetchMyProfileData() -> Observable<UserProfile?>
}

protocol HomeViewModelOutput {
    
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

class DefaultHomeViewModel: HomeViewModel {
    
    var actionDelegate: HomeViewModelActionDelegate?

    private let fetchDataUseCase: FetchDataUseCase
    
    let disposeBag = DisposeBag()
    
    // MARK: - OUTPUT
    
    
    // MARK: - Initailize
    
    init(fetchDataUseCase: FetchDataUseCase) {
        self.fetchDataUseCase = fetchDataUseCase
    }
    
}

// MARK: - INPUT. View event methods

extension DefaultHomeViewModel {
    
    func fetchMyProfileData() -> Observable<UserProfile?> {
        
        return fetchDataUseCase.excuteProfile()
            
    }
    
}

// MARK: - Action Delegate

extension DefaultHomeViewModel {
    
    func setupProfileView() {
        actionDelegate?.setupProfile()
    }
}
