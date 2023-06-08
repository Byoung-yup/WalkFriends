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
    
    func uploadImageData(with data: Data) async throws {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let fileRef = storage.reference().child("images/\(FirebaseService.shard.currentUser.uid)_profile.jpg")
        
        
        do {
             _ = try await fileRef.putDataAsync(data, metadata: metaData)
        } catch {
            throw DatabaseError.UnknownError
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
