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
//        let selectedImages: Observable<[UIImage]>
//        let titleText: Observable<String>
//        let memoText: Observable<String>
//        let submit: Observable<Void>
        let toBack: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let mapInfo: MapInfo
//        let save: Observable<Result<Bool, DatabaseError>>
        let dismiss: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    let actions: ShareInfoViewModelActions
    private let mapInfo: MapInfo
//    var actionDelegate: ShareInfoViewModelActionDelegate?
    
    // MARK:  - Initialize
    
    init(dataUseCase: DataUseCase, actions: ShareInfoViewModelActions, mapInfo: MapInfo) {
        self.dataUseCase = dataUseCase
        self.actions = actions
        self.mapInfo = mapInfo
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let dismiss = input.toBack
            .do(onNext: { [weak self] in
                self?.actions.toBack()
            })
        
//        let data = Observable.combineLatest(input.addressText, input.selectedImages, input.titleText, input.memoText) {
//            return UserMap(address: $0, images: $1, title: $2, subTitle: $3, popular: 0)
//        }
//
//        let save = input.submit.withLatestFrom(data)
//            .flatMapLatest { [weak self] in
//                (self?.dataUseCase.shareData(with: $0))!
//            }
////
//        let dismiss = input.cancel
//            .do(onNext: { [weak self] _ in
////                self?.actionDelegate?.dismiss()
//            })
        
        return Output(mapInfo: mapInfo, dismiss: dismiss)
    }
}

