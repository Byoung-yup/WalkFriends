//
//  RunViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/23.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class RunViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let run: Driver<Void>
        let stop: Driver<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let runTrigger: Driver<Void>
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    
    // MARK: - Initialize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let trigger = input.run
        
        return Output(runTrigger: trigger)
    }
    
}

