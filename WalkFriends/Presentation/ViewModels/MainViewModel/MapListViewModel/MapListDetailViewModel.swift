//
//  MapListDetailViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import RxSwift
import SDWebImage

struct MapListDetailViewModelActions {
    
}

final class MapListDetailViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let item: Observable<FinalMapList>
    }
    
    // MARK: - Properties
    
    private let item: Observable<FinalMapList>
    private let dataUseCase: DataUseCase
    let actions: MapListDetailViewModelActions
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase, item: FinalMapList, actions: MapListDetailViewModelActions) {
        self.dataUseCase = dataUseCase
        self.item = Observable.just(item)
        self.actions = actions
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        
        return Output(item: item)
    }
}
