//
//  LocationViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import RxSwift

struct LocationViewModelActions {
    let toBack: () -> Void
    let showLoginViewController: () -> Void
}

final class LocationViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let toBack_Trigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let toBack: Observable<Void>
    }
    
    // MARK: - Properties
    
    let actions: LocationViewModelActions
    
    deinit {
        print("LocationViewModel - deinit")
    }
    
    // MARK: - Init
    
    init(actions: LocationViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
            
        
        let toBack = input.toBack_Trigger
                
                
        
        return Output(toBack: toBack)
    }
}
