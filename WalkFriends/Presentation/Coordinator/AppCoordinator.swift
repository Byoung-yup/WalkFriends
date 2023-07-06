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
    
    func start() {
        
        if (FirebaseAuth.Auth.auth().currentUser != nil) {
            showMainViewController()
        } else {
            showLoginViewController()
        }
    }
    
//    private func showLaunchViewController() {
//        
//        let coordinator = LaunchCoordinator(navigationController: navigationController)
//        coordinator.start()
//        
//        childCoordinators.append(coordinator)
//    }
    
    private func showMainViewController() {
        
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        
        childCoordinators.append(coordinator)
        
    }
    
    private func showLoginViewController() {
        
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

extension AppCoordinator: HomeCoordinatorDelegate {
    
    func didLoggedOut(_ coordinator: HomeCoordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showLoginViewController()
    }
    
    func error(_ coordinator: HomeCoordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showLoginViewController()
    }
}
