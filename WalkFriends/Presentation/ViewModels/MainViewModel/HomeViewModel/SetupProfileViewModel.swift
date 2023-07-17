//
//  SetupProfileViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

struct SetupViewModelActions {
    let createProfile: () -> Void
}

final class SetupProfileViewModel: ViewModel {
    
    struct Input {
        let profileImage: Observable<UIImage>
        let usernickName: Observable<String>
        let createTrigger: Observable<Void>
    }
    
    struct Output {
        let create: Observable<Result<Bool, DatabaseError>>
        let createEnabled: Driver<Bool>
    }
    
    private let dataUseCase: DataUseCase
    let actions: SetupViewModelActions
    
    
    // MARK: - Initialize
    
    init(dataUseCase: DataUseCase, actions: SetupViewModelActions) {
        self.dataUseCase = dataUseCase
        self.actions = actions
    }
    
}

extension SetupProfileViewModel {
    
    func transform(input: Input) -> Output {
        
        let userInfo = FirebaseAuth.Auth.auth().currentUser?.providerData[0]
        
//        let gender = input.userGender.map { $0 == 0 ? "남자" : "여자" }
//
        let userProfile = Observable.combineLatest(input.profileImage, input.usernickName) { (image, nickname) in
            return UserProfileData(image: image, email: (userInfo?.email)!, nickName: nickname)
        }

        let canCreate = input.usernickName
            .map { $0.count >= 2 }
            .asDriver(onErrorJustReturn: false)

        let create = input.createTrigger.withLatestFrom(userProfile)
            .flatMapLatest { [weak self] data in
                return (self?.dataUseCase.createProfile(with: data))!
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] result in
                
                switch result {
                case .success(_):
                    self?.actions.createProfile()
                case .failure(_):
                    break
                }
            })
        
        return Output(create: create,
                      createEnabled: canCreate)
    }
}
