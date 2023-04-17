//
//  Reactive.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/17.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
