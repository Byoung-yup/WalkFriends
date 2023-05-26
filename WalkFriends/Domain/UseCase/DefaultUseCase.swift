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
//    func createProfile(with userProfile: UserProfile) -> Observable<Bool>
    func shareData(with userData: UserMap) -> Observable<[String]>
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
    
//    func createProfile(with userProfile: UserProfile) -> Observable<Bool> {
//        let jpegData = userProfile.image.convertData()
//
//        return Observable.create { [weak self] (observer) in
//
//            self?.storageRepository.uploadImageData(with: jpegData, completion: { result in
//
//                if result {
//                    self?.dataBaseRepository.createUserProfile(with: userProfile, completion: { result in
//
//                        if result {
//                            observer.onNext(true)
//                        } else {
//                            observer.onNext(false)
//                        }
//                    })
//                } else {
//                    observer.onNext(false)
//                }
//                observer.onCompleted()
//            })
//
//            return Disposables.create()
//        }
//    }
    
    
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
    
    func shareData(with userData: UserMap) -> Observable<[String]> {
        
        let jpegDatas = userData.images.map { $0.convertData() }
        let uid = UUID().uuidString
        
        
        return storageRepository.uploadImageArrayData(with: jpegDatas, uid: uid)
            .do(onNext: { [weak self] urls in
                self?.dataBaseRepository.createMapData(with: userData, uid: uid, urls: urls)
            })
        
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
