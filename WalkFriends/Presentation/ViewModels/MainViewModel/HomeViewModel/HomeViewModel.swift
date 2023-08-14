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
    let fetchError: () -> Void
    let showRunViewController: () -> Void
}

class HomeViewModel: ViewModel {
    
//    lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        return manager
//    }()
    
    let actions: HomeViewModelActions
    
    private let dataUseCase: DataUseCase
    
    let category_Items = Observable.just(["최신순", "인기순", "시간순", "거리순"])
    
//    let items = Observable.just([MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20"),
//                                 MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20"),
//                                 MapList(uid: "dddddddddddd", address: "서을특별시 종로구 서린동", imageUrls: [], title: "자연 그 자체", subTitle: "테스트 입니다", date: "2023-07-06", email: "qudduq9999@naver.com",popular: 4000, distance: "0.5km", time: "20")])
    
    // MARK: - INPUT
    
    struct Input {
        let default_Btn: Observable<Void>
        let popular_Btn: Observable<Void>
        let time_Btn: Observable<Void>
        let distance_Btn: Observable<Void>
    }
    
    // MARK: - OUTPUT
    
    struct Output {
        let fetchTrigger: Observable<Result<Bool, DatabaseError>>
        let toggle_Btn_Trigger: Observable<Category_Action>
        let fetch_MapList: Observable<Result<[MapList?], DatabaseError>>
    }
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase, actions: HomeViewModelActions) {
        self.dataUseCase = dataUseCase
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let fetch = dataUseCase.start()
        
        let toggle_Btn = Observable.merge(
            input.default_Btn.map { _ in Category_Action.Default },
            input.popular_Btn.map { _ in Category_Action.Popular },
            input.time_Btn.map { _ in Category_Action.Time },
            input.distance_Btn.map { _ in Category_Action.Distance }
        )
        
        let fetch_MapList = dataUseCase.fetchMapListData()
                
        return Output(fetchTrigger: fetch, toggle_Btn_Trigger: toggle_Btn, fetch_MapList: fetch_MapList)
    }
    
}

// MARK: - LocationManager
//extension HomeViewModel {
//    func checkUserDeviceLocationServiceAuthorization() {
//
//        let authorizationStatus: CLAuthorizationStatus
//
//        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
//        if #available(iOS 14.0, *) {
//            authorizationStatus = locationManager.authorizationStatus
//        }else {
//            authorizationStatus = CLLocationManager.authorizationStatus()
//        }
//
//        checkUserCurrentLocationAuthorization(authorizationStatus)
//    }
//
//    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
//
//        switch status {
//        case .notDetermined:
//            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
//
//            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
////            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//            // 권한 요청을 보낸다.
//            locationManager.requestWhenInUseAuthorization()
//
//        case .denied, .restricted:
//            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
//            // 시스템 설정에서 설정값을 변경하도록 유도한다.
//            // 시스템 설정으로 유도하는 커스텀 얼럿
//
//            DispatchQueue.main.async { [weak self] in
//
//                self?.showRequestLocationServiceAlert()
//            }
//
//        case .authorizedWhenInUse:
//            break
//            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
//            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
////            homeViewModel.actionDelegate?.run(locationManager: self.locationManager)
//
//        default:
//            print("Default")
//        }
//    }
//}
