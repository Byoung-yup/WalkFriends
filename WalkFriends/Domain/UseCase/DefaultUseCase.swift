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
import FirebaseStorage

protocol DataUseCase: UseCase {
//    func excuteProfile() -> Observable<Bool>
    func createProfile(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>>
    func createProfile2(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>>
    
    func shareData(with userData: UserMap) -> Observable<Result<Bool, DatabaseError>>
    func fetchMapListData() -> Observable<[MapList]>
//    func downLoadImages(urls: [String]) -> Observable<[Data]>
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
        
        return dataBaseRepository.fetchUserData()
    }
    
}

extension DefaultDataUseCase: DataUseCase {
    
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
    
    func createProfile2(with userProfile: UserProfileData) -> Observable<Result<Bool, DatabaseError>> {
        
        let jpegData = userProfile.image.convertJPEGData()
        
        return Observable.create { (observer) in
            
            let task = Task { [weak self] in
                
                guard let strongSelf = self else { return }
                             
                await withThrowingTaskGroup(of: Void.self) { group in
                    
                        group.addTask {
                            
                            do {
                                try await strongSelf.dataBaseRepository.createUserProfile(with: userProfile)
                            } catch {
                                observer.onNext(.failure(DatabaseError.UnknownError))
                                observer.onCompleted()
                            }
                            
                        }
                        
                        group.addTask {
                            
                            do {
                                try await strongSelf.storageRepository.uploadImageData(with: jpegData)
                            } catch {
                                observer.onNext(.failure(DatabaseError.UnknownError))
                                observer.onCompleted()
                            }
                            
                        }
                        
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
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
        
        let jpegDatas = userData.images.map { $0.convertJPEGData() }
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
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
                
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    func fetchMapListData() -> Observable<[MapList]> {
        
        return dataBaseRepository.fetchMapListData()
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
