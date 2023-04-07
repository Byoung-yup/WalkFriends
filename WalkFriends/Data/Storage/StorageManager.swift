//
//  StorageManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import FirebaseStorage

final class StorageManager: UserProfileImageRepository {
    
    private let storage = Storage.storage()
    
}

// MARK: - UserProfileImageRepository

extension StorageManager {
    
    func uploadImageData(with data: Data, completion: @escaping (Bool) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        let fileRef = storage.reference().child("images/\(UserInfo.shared.uid!)_profile.jng")
        
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
}
