//
//  InfoViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import RxSwift
import RxCocoa

protocol InfoViewControllerActionDelegate {
    func logOut() 
}

final class InfoViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let logout: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let logout_Trigger: Observable<Result<Bool, FirebaseAuthError>>
        
    }
    
    // MARK: - Properties
    
    var actionDelegate: InfoViewControllerActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let logout = input.logout
            .flatMap {
                return FirebaseService.shard.logout()
            }
        
        return Output(logout_Trigger: logout)
    }
}


