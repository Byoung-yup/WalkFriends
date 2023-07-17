//
//  Rx+ViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/14.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var isDismissing: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false}
                return base.isBeingDismissed
            }
    }
    
    var isPopping: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false}
                return base.isMovingFromParent
            }
    }
    
    var isDismissingWithNavigationController: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false}
                guard let navigationController = base.navigationController else { return false }
                return navigationController.isBeingDismissed
            }
    }
    
    var isPoppingWithNavigationController: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false}
                guard let navigationController = base.navigationController else { return false }
                return navigationController.isMovingFromParent
            }
    }
}
