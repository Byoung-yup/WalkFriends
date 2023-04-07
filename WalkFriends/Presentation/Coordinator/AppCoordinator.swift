//
//  AppCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit
import FirebaseAuth

protocol Coordinator: AnyObject  {
    var childCoordinators : [NSObject] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
//    let window: UIWindow
//
//    init(window: UIWindow) {
//        self.window = window
//    }
    
    func start() {
        
        if (UserInfo.shared.currentUser != nil) {
            showMainViewController()
        } else {
            showLoginViewController()
        }
    }
    
    private func showMainViewController() {
        
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.start()
        
        childCoordinators.append(coordinator)
        
//        let rootViewController = UITabBarController()
//        window.rootViewController = rootViewController
//
//        let coordinator = TabBarCoordinator(tabBarController: rootViewController)
//        coordinator.delegate = self
//        coordinator.start()
        
//        childCoordinators.append(coordinator)
    }
    
    private func showLoginViewController() {
        
//        let rootViewController = UINavigationController()
//        window.rootViewController = rootViewController
        
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        
        childCoordinators.append(coordinator)
        
    }
    
}

extension AppCoordinator: LoginCoordinatorDelegate {
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showMainViewController()
        
    }
}

//extension AppCoordinator: TabBarCoordinatorDelegate {
//
//    func didLoggedOut(_ coordinator: TabBarCoordinator) {
//        
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//        showLoginViewController()
//    }
//}
