//
//  MainViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

class HomeViewModel {
    
//    let disposeBag = DisposeBag()
    
}

extension HomeViewModel {
    
    // MARK: check User Profile
    func checkUserProfile() -> Observable<UserProfile?> {
        
        return Observable.create { observer in
            
            if let currentUser = FirebaseAuth.Auth.auth().currentUser {
                
                DatabaseManager.shared.loadUserProfile(user: currentUser.uid) { userProfile in
                    
                    if userProfile != nil {
                        observer.onNext(userProfile)
                    } else {
                        observer.onNext(nil)
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
