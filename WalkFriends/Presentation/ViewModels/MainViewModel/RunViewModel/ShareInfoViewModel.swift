//
//  ShareInfoViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import BSImagePicker

struct ShareInfoViewModelActions {
    let toBack: () -> Void
}

final class ShareInfoViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        //        let addressText: Observable<String>
        let selectedImages: Observable<[UIImage]>
        let titleText: Observable<String>
        let memoText: Observable<String>
        let timeText: Observable<String>
        let submit: Observable<Void>
        let toBack: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
//        let mapInfo: MapInfo
        let save_isEnabled: Observable<Bool>
        let save: Observable<Result<Bool, DatabaseError>>
        let dismiss: Observable<Void>
        let isLoding: Observable<Bool>
        let user_Map_Images: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    let actions: ShareInfoViewModelActions
    let mapInfo: MapInfo
    private let isLoding: PublishRelay<Bool> = PublishRelay()
    let user_Map_Images: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
    //    var actionDelegate: ShareInfoViewModelActionDelegate?
    
    // MARK:  - Initialize
    
    init(dataUseCase: DataUseCase, actions: ShareInfoViewModelActions, mapInfo: MapInfo) {
        self.dataUseCase = dataUseCase
        self.actions = actions
        self.mapInfo = mapInfo
//        user_Map_Images.accept([mapInfo.image])
    }
    
    deinit {
        print("ShareInfoViewModel - deinit")
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let dismiss = input.toBack
            .do(onNext: { [weak self] in
                guard let self = self else { fatalError() }
                self.actions.toBack()
            })
                let user_Map_Images: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [mapInfo.image])
                let user_Selected_Images = input.selectedImages
                .map { [weak self] in
                    guard let self = self else { fatalError() }
                    
                    user_Map_Images.accept([self.mapInfo.image] + $0)
                }
                
        let user_Map_InfoData = Observable.combineLatest(user_Map_Images, input.titleText, input.memoText, input.timeText)
            .map { [weak self] in
                guard let self = self else { fatalError() }
                
//                user_Map_Image.accept([self.mapInfo.image] + $0)
                print("images: \($0)")
                return UserMap(address: self.mapInfo.address, images: $0, title: $1, memo: $2, time: $3, popular: 0)
            }
        
        let save_isEnabled = user_Map_InfoData
            .map {
                return $0.images.count > 1 && !$0.title.isEmpty && !$0.memo.isEmpty && !$0.time.isEmpty
            }
        
        let save = input.submit.withLatestFrom(user_Map_InfoData)
            .flatMapLatest { [weak self] in
                guard let self = self else { fatalError() }
                
                self.isLoding.accept(true)
                return self.dataUseCase.shareData(with: $0)
            }
        
        
        return Output(save_isEnabled: save_isEnabled, save: save, dismiss: dismiss, isLoding: isLoding.asObservable(), user_Map_Images: user_Selected_Images)
    }
}

