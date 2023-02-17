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
    var childCoordinators : [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    
    let currentUser = FirebaseAuth.Auth.auth().currentUser
    
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        if ( currentUser != nil) {
            showMainViewController()
        } else {
            showLoginViewController()
        }
    }
    
    private func showMainViewController() {
        
        let coordinator = MainCoordinator(navigationController: navigationController)
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

extension AppCoordinator: MainCoordinatorDelegate {
    
    func didLoggedOut(_ coordinator: MainCoordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showLoginViewController()
    }
}
