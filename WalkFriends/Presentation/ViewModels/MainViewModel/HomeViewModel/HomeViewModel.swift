//
//  MainViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

enum Category_Action: Int {
    case Default = 100
    case Popular = 101
    case Time = 102
    case Distance = 103
}

//protocol HomeViewModelActionDelegate {
//    func setupProfile()
//    func error()
//    func run(locationManager: CLLocationManager)
//}

struct HomeViewModelActions {
    let showInfoViewController: () -> Void
    let showSetupProfileViewController: () -> Void
}

class HomeViewModel: ViewModel {
    
//    var actionDelegate: HomeViewModelActionDelegate?
    let actions: HomeViewModelActions
    private let dataUseCase: DataUseCase
    
    let category_Items = Observable.just(["최신순", "인기순", "시간순", "거리순"])
    
    let items = Observable.just([MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20"),
                                 MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20"),
                                 MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20")])
    
    // MARK: - INPUT
    
    struct Input {
        let default_Btn: Observable<Void>
        let popular_Btn: Observable<Void>
        let time_Btn: Observable<Void>
        let distance_Btn: Observable<Void>
    }
    
    // MARK: - OUTPUT
    
    struct Output {
        let fetchTrigger: Driver<Result<Bool, DatabaseError>>
        let toggle_Btn_Trigger: Observable<Category_Action>
    }
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase, actions: HomeViewModelActions) {
        self.dataUseCase = dataUseCase
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let fetch = dataUseCase.start()
            .asDriver(onErrorJustReturn: .failure(DatabaseError.DatabaseFetchError))
        
        let toggle_Btn = Observable.merge(
            input.default_Btn.map { _ in Category_Action.Default },
            input.popular_Btn.map { _ in Category_Action.Popular },
            input.time_Btn.map { _ in Category_Action.Time },
            input.distance_Btn.map { _ in Category_Action.Distance }
        )
                
        return Output(fetchTrigger: fetch, toggle_Btn_Trigger: toggle_Btn)
    }
    
}
