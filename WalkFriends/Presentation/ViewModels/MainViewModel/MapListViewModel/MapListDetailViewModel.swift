//
//  MapListDetailViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import RxSwift
import RxCocoa

final class MapListDetailViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let urls: Driver<[String]>
    }
    
    // MARK: - Properties
    
    private let item: MapList
    
    private let dataUseCase: DataUseCase
    
    // MARK: - Initailize
    
    init(dataUseCase: DataUseCase, item: MapList) {
        self.dataUseCase = dataUseCase
        self.item = item
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let imageUrls = Driver.just(item.imageUrls)
        
        return Output(urls: imageUrls)
    }
    
    // MARK: - Download Image Data

//    private func downloadImageData() -> Observable<[Data]> {
//
//        return dataUseCase.downLoadImages(urls: item.imageUrls)
//    }
}


