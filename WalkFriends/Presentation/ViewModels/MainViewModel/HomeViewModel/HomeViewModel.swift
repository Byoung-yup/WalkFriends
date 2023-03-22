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

class HomeViewModel: ViewModel {
    
    var actionDelegate: HomeViewModelActionDelegate?

    private let dataUseCase: DataUseCase
    
    let disposeBag = DisposeBag()
    
    let items = Observable.just(["Run", "Menu", "None", "Profile"])
    
    // MARK: - INPUT
    
    struct Input {
        
    }
    
    // MARK: - OUTPUT
    
    struct Output {
        
    }
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    
}

// MARK: - INPUT. View event methods

extension HomeViewModel {
    
    func fetchMyProfileData() -> Observable<UserProfile?> {
        
        return dataUseCase.excuteProfile()
            
    }
    
}

// MARK: - Action Delegate

extension HomeViewModel {
    
    func setupProfileView() {
        actionDelegate?.setupProfile()
    }
}
