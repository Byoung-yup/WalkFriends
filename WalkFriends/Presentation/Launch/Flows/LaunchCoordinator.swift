//
//  LaunchCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import UIKit

protocol LaunchCoordinatorDependencies {
    // MARK: Coordinator
    func makeLaunchCoordinator(navigationController: UINavigationController, dependencies: LocationCoordinatorDependencies) -> LocationCoordinator
    func makeLoginCoordinator(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) -> LoginCoordinator
    
    // MARK: - ViewController
    func makeLaunchViewController(actions: LaunchViewModelActions) -> LaunchViewController
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController
}

final class LaunchCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: LaunchCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: LaunchCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LaunchViewModelActions(showLocationViewController: showLocationViewController)
        let vc = dependencies.makeLaunchViewController(actions: actions)
        
        navigationController.viewControllers = [vc]
        navigationController.navigationBar.isHidden = true
        
    }
    
    private func showLocationViewController() {
        let locationCoordinator = dependencies.makeLaunchCoordinator(navigationController: navigationController, dependencies: self)
        locationCoordinator.start()
        
        childCoordinators.append(locationCoordinator)
    }
}

// MARK: - LocationCoordinatorDependencies
extension LaunchCoordinator: LocationCoordinatorDependencies {
    
    func makeLoginCoordinator(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) -> LoginCoordinator {
        return self.dependencies.makeLoginCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController {
        return dependencies.makeLocationViewController(actions: actions)
    }
    
    func toBack(_ coordinator: LocationCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
