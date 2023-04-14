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
    func shareData(with userData: UserMap) -> Observable<Bool>
    func fetchMapListData() -> Observable<Result<[MapList], DatabaseError>>
}

class DefaultDataUseCase {
    
    private let dataBaseRepository: DataRepository
    private let storageRepository: UserProfileImageRepository
    
    init(dataBaseRepository: DataRepository, storageRepository: UserProfileImageRepository) {
        self.dataBaseRepository = dataBaseRepository
        self.storageRepository = storageRepository
    }
    
}

extension DefaultDataUseCase: DataUseCase {
    
    func createProfile(with userProfile: UserProfile) -> Observable<Bool> {
        let jpegData = userProfile.image.convertData()
        
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
    
    func shareData(with userData: UserMap) -> Observable<Bool> {
        
        let jpegDatas = userData.images.map { $0.convertData() }
        
        return Observable.create { [weak self] (observer) in
            
            self?.dataBaseRepository.createMapData(with: userData, completion: { uid in
                
                self?.storageRepository.uploadImageArrayData(with: jpegDatas, uid: uid, completion: { result in
                    
                    if result {
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                })
            })
            
            return Disposables.create()
        }
        
    }
    
    func fetchMapListData() -> Observable<Result<[MapList], DatabaseError>> {
        
        
    }
}
