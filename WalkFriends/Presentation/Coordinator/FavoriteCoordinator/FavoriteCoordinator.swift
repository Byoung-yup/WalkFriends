//
//  FavoriteCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

final class FavoriteCoordinator: NSObject {
    
    var childCoordinators: [NSObject] = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FavoriteListViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
    
}
