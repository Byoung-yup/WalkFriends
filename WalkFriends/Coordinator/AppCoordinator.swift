//
//  AppCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol Coordinator  {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        isLoggedIn ? showMainViewController() : showLoginViewController()
    }
    
    private func showMainViewController() {
        
    }
    
    private func showLoginViewController() {
        
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start()
        
        childCoordinators.append(coordinator)
        
    }
    
}
