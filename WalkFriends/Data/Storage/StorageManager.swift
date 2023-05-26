//
//  StorageManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import FirebaseStorage
import RxSwift

final class StorageManager: ImageRepository {
    
    private let storage = Storage.storage()
    
}

// MARK: - ImageRepository

extension StorageManager {
    
    func uploadImageData(with data: Data, completion: @escaping (Bool) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        let fileRef = storage.reference().child("images/\(UserInfo.shared.uid!)_profile.jpg")
        
        fileRef.putData(data, metadata: metaData) { _, error in
            
            guard error == nil else {
                print("Storage Fetch Error")
                completion(false)
                return
            }
            
            print("Storage Fetch Success")
            completion(true)
            return
        }
    }
    
    func uploadImageArrayData(with data: [Data], uid: String) -> Observable<[String]> {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        var urls: [String] = []
        
        return Observable.create { (observer) in
            
            data.enumerated().forEach { [weak self] (index, item) in
                print("enumerated")
                
                let fileRef = self?.storage.reference().child("Maps/\(uid)/\(index).jpg")
                
                fileRef?.putData(item, metadata: metaData, completion: { meta, error in
                    
                    guard error == nil else {
                        observer.onError(DatabaseError.NotFoundUserError)
                        print("Storage put data error")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        fileRef?.downloadURL(completion: { url, error in
                            
                            guard let url = url, error == nil else {
                                observer.onError(DatabaseError.NotFoundUserError)
                                print("Storage download url error")
                                return
                            }
                            
                            urls.append(url.absoluteString)
                            
                            if urls.count == data.count {
                                observer.onNext(urls)
                                observer.onCompleted()
                            }
                        })
                    }
                })
            }
            
            
            return Disposables.create()
        }
        
        
        
    }
    

}
