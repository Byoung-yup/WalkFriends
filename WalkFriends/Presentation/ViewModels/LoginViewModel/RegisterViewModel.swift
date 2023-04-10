//
//  RegisterViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol RegisterViewModelActionDelegate {
    func toBack()
}

final class RegiterViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let emailConfirm: Observable<UITapGestureRecognizer>
        let back: Driver<Void>
    }
    
    // MARK: - Output
    
    struct Output {
//        let present: Driver<Void>
        let dismiss: Driver<Void>
    }
    
    // MARK: - Properties
    
    var actionDelegate: RegisterViewModelActionDelegate?
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let trigger = input.emailConfirm
        
        let dismiss = input.back
            .do(onNext: { [weak self] in
                self?.actionDelegate?.toBack()
            })
            
        
        return Output(dismiss: dismiss)
    }
    
}
