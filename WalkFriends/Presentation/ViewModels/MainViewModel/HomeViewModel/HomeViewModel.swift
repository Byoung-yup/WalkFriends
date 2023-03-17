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

    private let dataUseCase: DataUseCase
    
    let disposeBag = DisposeBag()
    
    // MARK: - OUTPUT
    
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
}

// MARK: - INPUT. View event methods

extension DefaultHomeViewModel {
    
    func fetchMyProfileData() -> Observable<UserProfile?> {
        
        return dataUseCase.excuteProfile()
            
    }
    
}

// MARK: - Action Delegate

extension DefaultHomeViewModel {
    
    func setupProfileView() {
        actionDelegate?.setupProfile()
    }
}
