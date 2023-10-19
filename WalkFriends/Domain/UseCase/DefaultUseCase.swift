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
//import FirebaseStorage

protocol DataUseCase: UseCase {
//    func excuteProfile() -> Observable<Bool>
    func createProfile(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>>
    func createProfile2(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>>
    
    func shareData(with userData: UserMap) -> Observable<Result<Bool, DatabaseError>>
    func shareData2(with userData: UserMap) -> Observable<Result<Bool, DatabaseError>>
    func fetchMapListData() -> Observable<Result<[FinalMapList], DatabaseError>>

    func fetchUserData(uid: String) -> Observable<FinalUserProfile>
}

class DefaultDataUseCase {
    
    private let dataBaseRepository: DataRepository
    private let storageRepository: ImageRepository
//    private let networkSession: NetworkService
    
    init(dataBaseRepository: DataRepository, storageRepository: ImageRepository) {
        self.dataBaseRepository = dataBaseRepository
        self.storageRepository = storageRepository
//        self.networkSession = networkService
    }
    
    func start() -> Observable<Result<Bool, DatabaseError>> {
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let self = self else { return }
                
                do {
                    try await self.dataBaseRepository.fetchUserData(uid: FirebaseService.shard.auth.currentUser!.uid)
                } catch let err as DatabaseError {
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}

extension DefaultDataUseCase: DataUseCase {
    
    func fetchUserData(uid: String) -> Observable<FinalUserProfile> {
        
        return Observable.create { (observer) in
            
            let task = Task {
                
                do {
                    print("uid: \(uid)")
                    let userData = try await self.dataBaseRepository.fetchUserData(uid: uid)
                    let finalUserData = try await self.storageRepository.fetch_UserProfileImageReference(userData: userData)
                    
                    observer.onNext(finalUserData)
                    observer.onCompleted()
                } catch let err as DatabaseError {
                    observer.onError(err)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func createProfile(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>> {

        let jpegData = userProfile.image.convertJPEGData()

        return Observable.create { (observer) in
            
            let task = Task { [weak self] in

                guard let strongSelf = self else { return }

                do {
                    
                    try await strongSelf.dataBaseRepository.createUserProfile(with: userProfile)
                    try await strongSelf.storageRepository.uploadImageData(with: jpegData)
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
//                    print("onNext:(true)")
                } catch let err as DatabaseError {
                    print("err: \(err)")
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func createProfile2(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>> {
        
        let jpegData = userProfile.image.convertJPEGData()
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let strongSelf = self else { return }
                
                do {
                    
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        
                            group.addTask {
                                
                                
                                    try await strongSelf.dataBaseRepository.createUserProfile(with: userProfile)
                                
                                print("dataBaseRepository.createUserProfile")
                            }
                            
                            group.addTask {
                                
                                
                                    try await strongSelf.storageRepository.uploadImageData(with: jpegData)
                               
                                print("storageRepository.uploadImageData")
                            }
                            
                    }
                    
                    observer.onNext(.success(true))
                    observer.onCompleted()
                    print("onNext")
                    return
                    
                } catch let err as DatabaseError {
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                    print("onNext(err)")
                    return
                }
                             
                
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
//    func excuteProfile() -> Observable<Bool> {
//        
//        return Observable.create { [weak self] (observer) in
//            
//            self?.dataBaseRepository.fetchUserProfile { result in
//                
//                switch result {
//                case .success(_):
//                    observer.onNext(true)
//                case .failure(_):
//                    observer.onNext(false)
//                }
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
    
    func shareData(with userData: UserMap) -> Observable<Result<Bool, DatabaseError>> {

        let jpegDatas = userData.imageDatas
        let uid = UUID().uuidString
        
        
//        return storageRepository.uploadImageArrayData(with: jpegDatas, uid: uid)
//            .do(onNext: { [weak self] urls in
//                self?.dataBaseRepository.createMapData(with: userData, uid: uid, urls: urls)
//            })
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let strongSelf = self else { return }
                
                do {
                    let urls = try await strongSelf.storageRepository.uploadImageArrayData2(with: jpegDatas, uid: uid)
                    try await strongSelf.dataBaseRepository.uploadMapData(with: userData, uid: uid, urls: urls)
                } catch let err as DatabaseError {
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
                return
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    func shareData2(with userData: UserMap) -> Observable<Result<Bool, DatabaseError>> {
        
        let jpegDatas = userData.imageDatas
        let uid = UUID().uuidString
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let strongSelf = self else { return }
                
                do {
                    try await strongSelf.storageRepository.uploadImageArrayData3(with: jpegDatas, uid: uid)
                    try await strongSelf.dataBaseRepository.uploadMapData2(with: userData, uid: uid)
                } catch let err as DatabaseError {
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
                return
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchMapListData() -> Observable<Result<[FinalMapList], DatabaseError>> {
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let self = self else { return }
                
                var finalMapLists: [FinalMapList] = []
                
                do {
                    let mapLists = try await self.dataBaseRepository.fetchMapListData3()
                    finalMapLists = try await self.storageRepository.fetch_MapListsImageReference(maplists: mapLists)
                    
                    observer.onNext(.success(finalMapLists))
                    observer.onCompleted()
                } catch let err as DatabaseError {
                    observer.onNext(.failure(err))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
}

extension URL {
    
    func downLoadImage() -> UIImage {
        
        var image: UIImage?
        
        URLSession.shared.dataTask(with: self) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Network Error")
                return
            }
            
            image = UIImage(data: data)!
        }
        return image!
    }
}

//extension ObservableType {
//
//    static func downLoadImages(_ urls: Observable<URL>) -> Observable<[UIImage]> {
//
//        let observables = Observable.combineLatest(urls) 
//
//        return Observable.merge(observables)
//    }
//}
