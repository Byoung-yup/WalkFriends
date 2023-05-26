//
//  MainViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa

enum Presenter: Int {
    case Run
    case Menu
    case None
    case Profile
}

protocol HomeViewModelActionDelegate {
    func setupProfile()
    func error()
    func present(from: Presenter)
}

class HomeViewModel: ViewModel {
    
    var actionDelegate: HomeViewModelActionDelegate?
    
    private let dataUseCase: DataUseCase
    
    let items = Observable.just(["Run", "Menu", "None", "Profile"])
    
    // MARK: - INPUT
    
    struct Input {
        let selectedMenu: Driver<IndexPath>
    }
    
    // MARK: - OUTPUT
    
    struct Output {
        let trigger: Driver<Presenter?>
        let fetchTrigger: Driver<Result<Bool, DatabaseError>>
    }
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let fetch = dataUseCase.start()
            .asDriver(onErrorJustReturn: .failure(DatabaseError.DatabaseFetchError))
        
        let dismiss = input.selectedMenu
            .map {
                return Presenter(rawValue: $0[1] )
            }.do(onNext: { [weak self] presenter in
                self?.actionDelegate?.present(from: presenter!)
            }).asDriver()
                
        return Output(trigger: dismiss,
                      fetchTrigger: fetch)
    }
    
}
//
//// MARK: - INPUT. View event methods
//
//extension HomeViewModel {
//
//    func fetchMyProfileData() -> Observable<Bool> {
//
//        return dataUseCase.excuteProfile()
//        
//    }
//
//}
//
//// MARK: - Action Delegate
//
//extension HomeViewModel {
//
//    func setupProfileView() {
//        actionDelegate?.setupProfile()
//    }
//}
