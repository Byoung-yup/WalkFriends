//
//  DefaultUseCase.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol DataUseCase {
    func excuteProfile() -> Observable<UserProfile?>
    func createProfile(with userProfile: UserProfile) -> Observable<Bool>
}

class DefaultDataUseCase {
    
    private let dataBaseRepository: UserProfileRepository
    
    init(dataBaseRepository: UserProfileRepository) {
        self.dataBaseRepository = dataBaseRepository
    }
    
}

extension DefaultDataUseCase: DataUseCase {
    
    func createProfile(with userProfile: UserProfile) -> Observable<Bool> {
        return (dataBaseRepository.createUserProfile(with: userProfile))
    }
    
    
    func excuteProfile() -> Observable<UserProfile?> {
        
        return Observable.create { observer in
            
            self.dataBaseRepository.fetchUserProfile { result in
                
                switch result {
                case .success(let userProfile):
                    observer.onNext(userProfile)
                case .failure(_):
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
