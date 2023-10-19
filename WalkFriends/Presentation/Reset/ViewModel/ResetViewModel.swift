//
//  ResetViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/02.
//

import Foundation
import RxSwift

struct ResetViewModelActions {
    let toBack: () -> Void
}

final class ResetViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let toBack_Trigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let toBack: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let actions: ResetViewModelActions
//    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(actions: ResetViewModelActions) {
        self.actions = actions
    }
    
    // MARK: - Transform Method
    
    func transform(input: Input) -> Output {
        
        let toBack = input.toBack_Trigger
            .do(onNext: actions.toBack )
                
        return Output(toBack: toBack)
    }
}
