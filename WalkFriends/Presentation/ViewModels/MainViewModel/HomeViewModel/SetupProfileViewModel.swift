//
//  SetupProfileViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import RxSwift
import RxCocoa

protocol SetupProfileViewModelActionDelegate {
    func createProfile()
}

final class SetupProfileViewModel: ViewModel {
    
    struct Input {
        let usernickName: Driver<String>
        let userGender: Driver<Int>
        let createTrigger: Driver<Void>
    }
    
    struct Output {
        let dismiss: Driver<Bool>
        let createBtdEnabled: Driver<Bool>
    }
    
    private let dataUseCase: DataUseCase
    
    var actionDelegate: SetupProfileViewModelActionDelegate?
    
    
    // MARK: - Initialize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
}

extension SetupProfileViewModel {
    
    func transform(input: Input) -> Output {
        
        let gender = input.userGender.map { $0 == 0 ? "남자" : "여자" }
        
        let userProfile = Driver.combineLatest(input.usernickName, gender)
        
        let canCreate = Driver.combineLatest(input.usernickName, input.userGender) {
            return !$0.isEmpty && !($1 == -1)
        }
        
        let create = input.createTrigger.withLatestFrom(userProfile)
            .map { (nickName, gender) in
                return UserProfile(imageUrl: "none", email: UserInfo.shared.email!, nickName: nickName, gender: gender)
            }
            .flatMapLatest { [weak self] in
                return (self?.dataUseCase.createProfile(with: $0)
                    .asDriver(onErrorJustReturn: false))!
            }

        return Output(dismiss: create, createBtdEnabled: canCreate)
    }
}
