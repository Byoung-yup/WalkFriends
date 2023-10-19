//
//  LaunchViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import RxSwift

struct LaunchViewModelActions {
    let showLocationViewController: () -> Void
}

final class LaunchViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let location_Trigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let show_Location: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let actions: LaunchViewModelActions
    
    // MARK: - Init
    
    init(actions: LaunchViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let show_Location = input.location_Trigger
            .do(onNext: actions.showLocationViewController )
        
        return Output(show_Location: show_Location)
    }
}
