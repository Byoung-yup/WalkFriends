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
//        let viewWillAppear: Driver<Bool>
    }
    
    // MARK: - Output
    
    struct Output {
        let mapList: Observable<[MapList]>
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    
    // MARK: - Initialize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let mapListData = fetchMapListData()
        
        return Output(mapList: mapListData)
    }
    
    // MARK: FetchMapListData
    
    func fetchMapListData() -> Observable<[MapList]> {
        
        return dataUseCase.fetchMapListData()
    }
}
