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
    func makeHomeCoordinator(navigationController: UINavigationController, dependencies: HomeCoordinatorDependencies) -> HomeCoordinator
    func makeSetupProfileCoordinator(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) -> SetupProfileCoordinator
    
    // MARK: - ViewController
    func makeLaunchViewController(actions: LaunchViewModelActions) -> LaunchViewController
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController
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
    
    private func showHomeViewController() {
        let homeCoordinator = dependencies.makeHomeCoordinator(navigationController: navigationController, dependencies: self)
        homeCoordinator.start()
        
        childCoordinators.append(homeCoordinator)
    }
    
    private func showSetupProfileViewController() {
        let setupCoordinator = dependencies.makeSetupProfileCoordinator(navigationController: navigationController, dependencies: self)
        setupCoordinator.start()
        
        childCoordinators.append(setupCoordinator)
    }
}

// MARK: - LocationCoordinatorDependencies

extension LaunchCoordinator: LocationCoordinatorDependencies {
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return dependencies.makeLoginViewController(actions: actions)
    }
    
    func makeLoginCoordinator(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) -> LoginCoordinator {
        return self.dependencies.makeLoginCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController {
        return dependencies.makeLocationViewController(actions: actions)
    }
    
    func toBack(_ coordinator: LocationCoordinator, _ createUser_Trigger: Bool?) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        
        guard let isExisted = createUser_Trigger else { return }
        
        if isExisted {
            navigationController.popToRootViewController(animated: false)
            showHomeViewController()
        } else {
            navigationController.popToRootViewController(animated: false)
            showSetupProfileViewController()
        }
    }
}

// MARK: - LocationCoordinatorDependencies

extension LaunchCoordinator: HomeCoordinatorDependencies {
    
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return dependencies.makeHomeViewController(actions: actions)
    }
}

// MARK: - SetupProfileCoordinatorDependencies

extension LaunchCoordinator: SetupProfileCoordinatorDependencies {
    
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController {
        return dependencies.makeSetupProfileViewController(actions: actions)
    }
    
    func dismiss(_ coordinator: SetupProfileCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        navigationController.popToRootViewController(animated: false)
        showHomeViewController()
    }
}
