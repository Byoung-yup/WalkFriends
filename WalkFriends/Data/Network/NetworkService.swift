//
//  NetworkService.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/05/04.
//

import Foundation
import RxSwift

enum NetworkSessionError: Error {
    case invalidURL, notFound
}


final class NetworkSession {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
}

// MARK:

extension NetworkSession: NetworkService {
//    
//    func dataTask(url: String) -> Observable<Data> {
//        
//        return Observable.create { [weak self] (observer) in
//            
//            guard let url = URL(string: url) else {
//                observer.onError(NetworkSessionError.invalidURL)
//                return
//            }
//            
//            let request = URLRequest(url: url)
//            
//            let task = self?.session.dataTask(with: request, completionHandler: { data, response, error in
//                
//                if let error = error {
//                    print("error in downloading image: \(error)")
//                    observer.onError(NetworkSessionError.notFound)
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
//                    observer.onError(NetworkSessionError.notFound)
//                    return
//                }
//                
//                if let data = data {
//                    observer.onNext(data)
//                    observer.onCompleted()
//                }
//            }).resume()
//            
//            return Disposables.create(with: task.cancel)
//        }
//    }
}
