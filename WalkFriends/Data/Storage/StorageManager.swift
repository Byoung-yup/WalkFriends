////
////  StorageManager.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/02/07.
////
//
import Foundation
import FirebaseStorage
import RxSwift
import FirebaseAuth
import SwiftKeychainWrapper

final class StorageManager: ImageRepository {

    private let storageRef = Storage.storage().reference()

}
//
// MARK: - ImageRepository
//
extension StorageManager {
    
    func createUserProfile(with data: Data) -> Observable<Result<Bool, FBError>> {
        
        let uid = KeychainWrapper.standard.string(forKey: "UID") ?? ""
        
        return Observable.create { [weak self] (observer) in
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            self?.storageRef.child("images/\(uid)/profile.jpeg").putData(data, metadata: metaData) { (metadata, error) in
                
                guard error == nil else {
                    print("Storage 업로드 실패")
                    observer.onNext(.failure(.UnknownError))
                    observer.onCompleted()
                    return
                }
                print("Storage 업로드 성공")
                observer.onNext(.success(true))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }

//    func uploadImageData(with data: Data) async throws {
//
//        guard let uid = FirebaseService.shard.auth.currentUser?.uid else {
//            throw DatabaseError.UnknownError
//        }
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        let fileRef = storageRef.child("images/\(uid)/profile.jpeg")
//
//        do {
//             _ = try await fileRef.putDataAsync(data, metadata: metaData)
//        } catch {
//            throw DatabaseError.UnknownError
//        }
//
//    }
//
////    func uploadImageArrayData(with data: [Data], uid: String) -> Observable<[String]> {
////
////        let metaData = StorageMetadata()
////        metaData.contentType = "image/jpg"
////
////        var urls: [String] = []
////
////        return Observable.create { (observer) in
////
////            data.enumerated().forEach { [weak self] (index, item) in
////                print("enumerated")
////
////                let fileRef = self?.storage.reference().child("Maps/\(uid)/\(index).jpg")
////
////                fileRef?.putData(item, metadata: metaData, completion: { meta, error in
////
////                    guard error == nil else {
////                        observer.onError(DatabaseError.NotFoundUserError)
////                        print("Storage put data error")
////                        return
////                    }
////
////                    DispatchQueue.main.async {
////
////                        fileRef?.downloadURL(completion: { url, error in
////
////                            guard let url = url, error == nil else {
////                                observer.onError(DatabaseError.NotFoundUserError)
////                                print("Storage download url error")
////                                return
////                            }
////
////                            urls.append(url.absoluteString)
////
////                            if urls.count == data.count {
////                                observer.onNext(urls)
////                                observer.onCompleted()
////                            }
////                        })
////                    }
////                })
////            }
////
////
////            return Disposables.create()
////        }
////
////
////
////    }
//
//    func uploadImageArrayData2(with data: [Data], uid: String) async throws -> [String] {
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        return try await withThrowingTaskGroup(of: String.self) { group in
//
//            var urls: [String] = []
//
//            for (index, item) in data.enumerated() {
//
//                let fileRef = storageRef.child("Maps/\(uid)/\(index).jpeg")
//
//                group.addTask {
//
//                    do {
//                        _ = try await fileRef.putDataAsync(item, metadata: metaData)
//                        let url = try await fileRef.downloadURL()
//                        return url.absoluteString
//                    } catch let err {
//                        print("err: \(err.localizedDescription)")
//                        throw DatabaseError.UnknownError
//                    }
//                }
//
//                for try await url in group {
//                    urls.append(url)
//                }
//            }
//            return urls
//        }
//    }
//
//    func uploadImageArrayData3(with data: [Data], uid: String) async throws {
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        return await withThrowingTaskGroup(of: Void.self) { group in
//
////            var refArrays: [StorageReference] = []
//
//            for (index, item) in data.enumerated() {
//
//                let fileRef = storageRef.child("Maps/\(uid)/\(index).jpeg")
//
//                group.addTask {
//
//                    do {
//                        _ = try await fileRef.putDataAsync(item, metadata: metaData)
//                    } catch let err {
//                        print("err: \(err.localizedDescription)")
//                        throw DatabaseError.UnknownError
//                    }
//                }
//            }
//        }
//    }
//
//    func fetch_MapListsImageReference(maplists: [MapList]) async throws -> [FinalMapList] {
//
//        return try await withThrowingTaskGroup(of: FinalMapList.self) { group in
//
//            for maplist in maplists {
//
//                let fileRef = storageRef.child("Maps/\(maplist.uid)/")
//
//                group.addTask {
//
//                    do {
//                        let refAll = try await fileRef.listAll().items
//                        return FinalMapList(reference: refAll, mapList: maplist)
//                    } catch {
//                        throw DatabaseError.UnknownError
//                    }
//                }
//            }
//
//            return try await group
//                .reduce(into: [FinalMapList](), { $0.append($1) })
//        }
//    }
//
//    func fetch_UserProfileImageReference(userData: UserProfile) async throws -> FinalUserProfile {
//
//        let fileRef = storageRef.child("images/\(userData.uid)/")
//
//        do {
//            let image_Reference = try await fileRef.list(maxResults: 1).items.first!
//            print("image_Reference: \(image_Reference)")
//            return FinalUserProfile(reference: image_Reference, profile: userData)
//        } catch {
//            throw DatabaseError.UnknownError
//        }
//    }
}
