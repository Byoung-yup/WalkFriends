//
//  StorageRepository.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/06/13.
//

import Foundation
import RxSwift
import FirebaseStorage

protocol ImageRepository {
    func uploadImageData(with data: Data) async throws
//    func uploadImageArrayData(with data: [Data], uid: String, completion: @escaping (Result<Bool, DatabaseError>) -> Void)
//    func uploadImageArrayData(with data: [Data], uid: String) -> Observable<[String]>
    func uploadImageArrayData2(with data: [Data], uid: String) async throws -> [String]
    func uploadImageArrayData3(with data: [Data], uid: String) async throws
//    func downLoadImages(uid: String) -> [URL]
    func fetchImageReference(maplists: [MapList]) async throws -> [FinalMapList]
}
