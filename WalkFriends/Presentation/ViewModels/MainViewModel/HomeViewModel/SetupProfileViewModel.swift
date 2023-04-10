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
        let profileImage: Driver<UIImage>
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
        
        let userProfile = Driver.combineLatest(input.profileImage, input.usernickName, gender) { (image, nickname, gender) in
            return UserProfile(image: image, email: UserInfo.shared.email!, nickName: nickname, gender: gender)
        }
        
        let canCreate = Driver.combineLatest(input.usernickName, input.userGender) {
            return !$0.isEmpty && !($1 == -1)
        }
        
        let create = input.createTrigger.withLatestFrom(userProfile)
            .flatMapLatest{ [weak self] userprofile in
                return (self?.dataUseCase.createProfile(with: userprofile)
                    .asDriver(onErrorJustReturn: false))!
            }.do(onNext: { [weak self] _ in
                self?.actionDelegate?.createProfile()
            })
        
        return Output(dismiss: create, createBtdEnabled: canCreate)
    }
}
