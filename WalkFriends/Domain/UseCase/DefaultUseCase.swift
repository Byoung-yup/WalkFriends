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
    func excuteProfile() -> Observable<Bool>
    func createProfile(with userProfile: UserProfile) -> Observable<Bool>
}

class DefaultDataUseCase {
    
    private let dataBaseRepository: UserProfileRepository
    private let storageRepository: UserProfileImageRepository
    
    init(dataBaseRepository: UserProfileRepository, storageRepository: UserProfileImageRepository) {
        self.dataBaseRepository = dataBaseRepository
        self.storageRepository = storageRepository
    }
    
}

extension DefaultDataUseCase: DataUseCase {
    
    func createProfile(with userProfile: UserProfile) -> Observable<Bool> {
        let jpegData = convertData(with: userProfile.image)
        
        return Observable.create { [weak self] (observer) in
            
            self?.storageRepository.uploadImageData(with: jpegData, completion: { result in
                
                if result {
                    self?.dataBaseRepository.createUserProfile(with: userProfile, completion: { result in
                        
                        if result {
                            observer.onNext(true)
                        } else {
                            observer.onNext(false)
                        }
                    })
                } else {
                    observer.onNext(false)
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
        
//        storageRepository.uploadImageData(with: jpegData) { [weak self] _ in
//
//            return Observable.create { (observer) in
//
//                self?.dataBaseRepository.createUserProfile(with: userProfile) { result in
//                    if result { observer.onNext(true) }
//                    else { observer.onNext(false) }
//                    observer.onCompleted()
//                }
//
//                return Disposables.create()
//            }
//        }
    }
    
    
    func excuteProfile() -> Observable<Bool> {
        
        return Observable.create { observer in
            
            self.dataBaseRepository.fetchUserProfile { result in
                
                switch result {
                case .success(_):
                    observer.onNext(true)
                case .failure(_):
                    observer.onNext(false)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

// MARK: - convert image to jpegData

extension DefaultDataUseCase {
    
    func convertData(with image: UIImage) -> Data {
        
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        return data
    }
}
