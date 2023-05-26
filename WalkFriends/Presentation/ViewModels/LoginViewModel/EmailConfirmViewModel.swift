//
//  EmailConfirmViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class EmailConfirmViewModel: ViewModel {
    
    // MARK: - Input
    struct Input {
        let text: Driver<String>
        let tap: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
}
