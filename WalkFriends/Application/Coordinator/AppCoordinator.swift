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
    private let appSceneDIContainer: AppSceneDIContainer
    
    init(navigationController: UINavigationController, appSceneDIContainer: AppSceneDIContainer) {
        self.navigationController = navigationController
        self.appSceneDIContainer = appSceneDIContainer
    }
    
    func start() {
        
        appSceneDIContainer.delegate = self
        
        if (FirebaseAuth.Auth.auth().currentUser != nil) {
            makeHomeCoordinator()
        } else {
            makeLoginCoordinator()
        }
    }
    
//    private func showLaunchViewController() {
//        
//        let coordinator = LaunchCoordinator(navigationController: navigationController)
//        coordinator.start()
//        
//        childCoordinators.append(coordinator)
//    }
    
    private func makeLoginCoordinator() {
        let loginCoordinator = appSceneDIContainer.makeLoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
        
        childCoordinators.append(loginCoordinator)
    }
    
    private func makeHomeCoordinator() {
        let homeCoordinator = appSceneDIContainer.makeHomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
        
        childCoordinators.append(homeCoordinator)
    }
    
//    private func showMainViewController() {
//
//        let coordinator = HomeCoordinator(navigationController: navigationController)
//        coordinator.delegate = self
//        coordinator.start()
//
//        childCoordinators.append(coordinator)
//
//    }
//
//    private func showLoginViewController() {
//
//        let coordinator = LoginCoordinator(navigationController: navigationController)
//        coordinator.delegate = self
//        coordinator.start()
//
//        childCoordinators.append(coordinator)
//
//    }
    
}

extension AppCoordinator: AppSceneDIContainerDelegate {
    
    func dismiss(coordinator: Coordinator) {
        print("Before childCoordinators: \(childCoordinators)")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        print("After childCoordinators: \(childCoordinators)")
        switch coordinator {
        case is LoginCoordinator:
            makeHomeCoordinator()
        case is HomeCoordinator:
            makeLoginCoordinator()
        default:
            break
        }
    }
}

//extension AppCoordinator: LoginCoordinatorDelegate {
//
//    func didLoggedIn(_ coordinator: LoginCoordinator) {
//
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//        showMainViewController()
//
//    }
//}
//
//extension AppCoordinator: HomeCoordinatorDelegate {
//    
//    func didLoggedOut(_ coordinator: HomeCoordinator) {
//        
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//        showLoginViewController()
//    }
//    
//    func error(_ coordinator: HomeCoordinator) {
//        
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//        showLoginViewController()
//    }
//}
