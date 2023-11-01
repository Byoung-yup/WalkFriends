//
//  LocationCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import UIKit

protocol LocationCoordinatorDependencies {
    
    // MARK: Coordinator
    func makeLoginCoordinator(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) -> LoginCoordinator
    
    // MARK: ViewController
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    
    // MARK: Dismiss
    func toBack(_ coordinator: LocationCoordinator)
}

final class LocationCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    private let navigationController: UINavigationController
    private let dependencies: LocationCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: LocationCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LocationViewModelActions(toBack: toBack,
                                               showLoginViewController: showLoginViewController)
        let vc = dependencies.makeLocationViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    
    private func toBack() {
        navigationController.popViewController(animated: true)
        dependencies.toBack(self)
    }
    
    private func showLoginViewController() {
        let loginCoordinator = dependencies.makeLoginCoordinator(navigationController: navigationController, dependencies: self)
        loginCoordinator.start()
        
        childCoordinators.append(loginCoordinator)
    }
}

extension LocationCoordinator: LoginCoordinatorDependencies {
    
    func dismiss(_ coordinator: LoginCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return dependencies.makeLoginViewController(actions: actions)
    }
}
