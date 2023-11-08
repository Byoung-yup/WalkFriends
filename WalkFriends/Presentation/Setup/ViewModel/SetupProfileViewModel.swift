//
//  SetupProfileViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import RxSwift
//import FirebaseAuth

struct SetupViewModelActions {
//    let createProfile: () -> Void
}

final class SetupProfileViewModel: ViewModel {
    
    struct Input {
//        let profileImage: Observable<UIImage>
//        let usernickName: Observable<String>
//        let createTrigger: Observable<Void>
    }
    
    struct Output {
//        let create: Observable<Result<Bool, DatabaseError>>
//        let createEnabled: Observable<Bool>
//        let isLoding: Observable<Bool>
    }
    
    private let dataUseCase: DatabaseUsecase
    let actions: SetupViewModelActions
//    private let isLoding: PublishSubject<Bool> = PublishSubject()
    
    // MARK: - Initialize
    
    init(dataUseCase: DatabaseUsecase, actions: SetupViewModelActions) {
        self.dataUseCase = dataUseCase
        self.actions = actions
    }
    
    deinit {
        print("SetupProfileViewModel - deinit")
    }
}

extension SetupProfileViewModel {
    
    func transform(input: Input) -> Output {
        
//        guard let email = FirebaseService.shard.auth.currentUser?.providerData[0].email else { fatalError() }
//
//        let userProfile = Observable.combineLatest(input.profileImage, input.usernickName) { (image, nickname) in
//            return UserProfileData(image: image, email: email, nickName: nickname)
//        }
//
//        let isEnabled = input.usernickName
//            .map { $0.count >= 2 }
//
//        let create = input.createTrigger.withLatestFrom(userProfile)
//            .flatMapLatest { [weak self] data in
//
//                guard let self = self else { fatalError() }
//
//                self.isLoding.onNext(true)
//                return self.dataUseCase.createProfile(with: data)
//
//            }
//            .observe(on: MainScheduler.instance)
//            .do(onNext: { [weak self] _ in
//
//                guard let self = self else { return }
//
//                self.isLoding.onNext(false)
//            })
//
        return Output()
    }
}
