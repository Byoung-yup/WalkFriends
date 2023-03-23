//
//  RunViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/23.
//

import Foundation

final class RunViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    
    // MARK: - Initialize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
