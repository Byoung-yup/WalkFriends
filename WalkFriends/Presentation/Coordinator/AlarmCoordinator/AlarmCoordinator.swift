//
//  AlarmCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

final class AlarmCoordinator: NSObject {
    
    var childCoordinators: [NSObject] = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AlarmViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
    
}