//
//  ViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/17.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
