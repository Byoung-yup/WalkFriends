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
    let createProfile: () -> Void
}

final class SetupProfileViewModel: ViewModel {
    
    struct Input {
        let profileImageData: Observable<UIImage>
        let usernickName: Observable<String>
        let createTrigger: Observable<Void>
    }
    
    struct Output {
        let create: Observable<Result<Bool, FBError>>
        let createEnabled: Observable<Bool>
    }
    
    private let dataUseCase: DatabaseUsecase
    let actions: SetupViewModelActions
    let isLoding: PublishSubject<Bool> = PublishSubject()
    
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
        
        let imageData = input.profileImageData
            .map { $0.jpegData(compressionQuality: 0.7) }

        let userProfile = Observable.combineLatest(imageData, input.usernickName) { return UserProfileData(imageData: $0!, nickName: $1) }
        
        let isEnabled = input.usernickName
            .map { $0.count >= 2 }
        
        let create = input.createTrigger.withLatestFrom(userProfile)
            .flatMapLatest { [weak self] in
                
                guard let self = self else { fatalError() }
                
                self.isLoding.onNext(true)
                return self.dataUseCase.createUser(with: $0)
                
            }
        
        return Output(create: create,
                      createEnabled: isEnabled)
    }
}
