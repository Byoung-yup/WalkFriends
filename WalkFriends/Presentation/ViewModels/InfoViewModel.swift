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
        let logout: Driver<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: Driver<Void>
        
    }
    
    // MARK: - Properties
    
    var actionDelegate: InfoViewControllerActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let logout = input.logout
            .do(onNext: { [weak self] in
                self?.actionDelegate?.logOut()
            })
        
        return Output(dismiss: logout)
    }
}


