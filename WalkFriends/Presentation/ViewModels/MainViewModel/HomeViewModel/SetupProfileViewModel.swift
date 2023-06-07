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
        let profileImage: Observable<UIImage>
        let usernickName: Observable<String>
        let userGender: Observable<Int>
        let createTrigger: Observable<Void>
    }
    
    struct Output {
//        let dismiss: Driver<Bool>
        let createEnabled: Driver<Bool>
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

        let userProfile = Observable.combineLatest(input.profileImage, input.usernickName, gender) { (image, nickname, gender) in
            return UserProfileData(image: image, email: UserInfo.shared.email!, nickName: nickname, gender: gender)
        }

        let canCreate = Observable.combineLatest(input.usernickName, input.userGender) {
            return !$0.isEmpty && !($1 == -1)
        }.asDriver(onErrorJustReturn: false)

        let create = input.createTrigger.withLatestFrom(userProfile)
            .flatMapLatest{ [weak self] userprofile in
                
                guard let strongSelf = self else { return }
                
                return strongSelf.dataUseCase.
        
        return Output(createEnabled: canCreate)
    }
}
