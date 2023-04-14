//
//  MapListViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation
import RxSwift
import RxCocoa

final class MapListViewModel: ViewModel {
    
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
    
    // MARK: FetchMapListData
    
    func fetchMapListData() {
        
        dataUseCase
    }
}
