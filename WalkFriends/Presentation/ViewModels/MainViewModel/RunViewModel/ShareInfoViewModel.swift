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

protocol ShareInfoViewModelActionDelegate {
    func dismiss()
}

final class ShareInfoViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let addressText: Driver<String>
        let selectedImages: Driver<[UIImage]>
        let titleText: Driver<String>
        let memoText: Driver<String>
        let submit: Driver<Void>
        let cancel: Driver<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let save: Driver<[String]>
        let dismiss: Driver<Void>
    }
    
    // MARK: - Properties
    
    private let dataUseCase: DataUseCase
    
    var actionDelegate: ShareInfoViewModelActionDelegate?
    
    // MARK:  - Initialize
    
    init(dataUseCase: DataUseCase) {
        self.dataUseCase = dataUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let data = Driver.combineLatest(input.addressText, input.selectedImages, input.titleText, input.memoText) {
            return UserMap(address: $0, images: $1, title: $2, subTitle: $3)
        }
        
        let save = input.submit.withLatestFrom(data)
            .flatMapLatest { [weak self] in
                (self?.dataUseCase.shareData(with: $0).asDriver(onErrorJustReturn: [""]))!
            }.do(onNext: { [weak self] _ in
                self?.actionDelegate!.dismiss()
            })
//
        let dismiss = input.cancel
            .do(onNext: { [weak self] _ in
                self?.actionDelegate?.dismiss()
            })
        
        return Output(save: save, dismiss: dismiss)
    }
}

