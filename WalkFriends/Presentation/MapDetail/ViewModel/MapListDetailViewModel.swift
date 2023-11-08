////
////  MapListDetailViewModel.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/04/18.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//struct MapListDetailViewModelActions {
//    
//}
//
//struct Item {
//    let mapData: FinalMapList
//    let userData: FinalUserProfile
//}
//
//final class MapListDetailViewModel: ViewModel {
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
//        let userData: Observable<Item>
//    }
//    
//    // MARK: - Properties
//    
//    let item: FinalMapList
//    private let dataUseCase: DataUseCase
//    let actions: MapListDetailViewModelActions
////    private let disposeBag = DisposeBag()
//    
//    // MARK: - Initailize
//    
//    init(dataUseCase: DataUseCase, item: FinalMapList, actions: MapListDetailViewModelActions) {
//        self.dataUseCase = dataUseCase
//        self.item = item
//        self.actions = actions
//    }
//    
//    // MARK: - Transform
//    
//    func transform(input: Input) -> Output {
//        
////        let items: BehaviorRelay<[Any]> = BehaviorRelay(value: [item.mapList])
//    
//        let items = dataUseCase.fetchUserData(uid: item.mapList.writer)
//            .map { [weak self] in
//                
//                guard let self = self else { fatalError() }
//                
//                return Item(mapData: self.item, userData: $0)
//            }
//            
//        
//        return Output(userData: items)
//    }
//}
//
//
