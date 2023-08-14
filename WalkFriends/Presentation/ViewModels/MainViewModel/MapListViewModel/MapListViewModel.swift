////
////  MapListViewModel.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/04/14.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//protocol MapListViewModelActionDelegate {
//    func showDetailVC(with item: MapList)
//}
//
//final class MapListViewModel: ViewModel {
//    
//    // MARK: - Input
//    
//    struct Input {
//        
//    }
//    
//    // MARK: - Output
//    
//    struct Output {
//        let mapList: Driver<[MapList]>
//    }
//    
//    // MARK: - Properties
//    
//    private let dataUseCase: DataUseCase
//    
//    var actionDelegate: MapListViewModelActionDelegate?
//    
//    // MARK: - Initialize
//    
//    init(dataUseCase: DataUseCase) {
//        self.dataUseCase = dataUseCase
//    }
//    
//    // MARK: - Transform
//    
//    func transform(input: Input) -> Output {
//        
////        let mapListData = fetchMapListData()
////            .asDriver(onErrorRecover: { _ in fatalError() })
////        
////        return Output(mapList: mapListData)
//    }
//    
//    // MARK: FetchMapListData
//    
////    func fetchMapListData() -> Observable<[MapList]> {
////
////        return dataUseCase.fetchMapListData()
////    }
//}
