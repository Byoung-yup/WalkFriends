//
//  HomeCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit
import CoreLocation

protocol HomeCoordinatorDepedencies {
    // MARK: coordinator
    func makeSetupProfileCoordinator(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) -> SetupProfileCoordinator
    func makeInfoCoordinator(navigationController: UINavigationController, dependencies: InfoCoordinatorDependencies) -> InfoCoordinator
    func makeRunCoordinator(navigationController: UINavigationController, dependencies: RunCoordinatorDependencies) -> RunCoordinator
    
    // MARK: viewController
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController
    func makeRunViewController(actions: RunViewModelActions) -> RunViewController
    
    // MARK: dismiss
    func dismissHomeViewController(_ coordinator: HomeCoordinator)
}


final class HomeCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: HomeCoordinatorDepedencies
    
    init(navigationController: UINavigationController, dependencies: HomeCoordinatorDepedencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showInfoViewController: showInfoViewController,
                                           showSetupProfileViewController: showSetupProfileViewController,
                                           fetchError: fetchError,
                                           showRunViewController: showRunViewController)
        let vc = dependencies.makeHomeViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = false
    }
    
    private func showInfoViewController() {
        let infoCoordinator = dependencies.makeInfoCoordinator(navigationController: navigationController, dependencies: self)
        infoCoordinator.start()
        
        childCoordinators.append(infoCoordinator)
    }
    
    private func showSetupProfileViewController() {
        let setupProfileCoordinator = dependencies.makeSetupProfileCoordinator(navigationController: navigationController, dependencies: self)
        setupProfileCoordinator.start()
        
        childCoordinators.append(setupProfileCoordinator)
    }
    
    private func fetchError() {
        dependencies.dismissHomeViewController(self)
    }
    
    private func showRunViewController() {
        let runCoordinator = dependencies.makeRunCoordinator(navigationController: navigationController, dependencies: self)
        runCoordinator.start()
        
        childCoordinators.append(runCoordinator)
    }
}

extension HomeCoordinator: InfoCoordinatorDependencies {
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController {
        return dependencies.makeInfoViewController(actions: actions)
    }
    
    func dismiss(_ coordinator: InfoCoordinator, status signOut: Bool) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        if signOut { dependencies.dismissHomeViewController(self) }
    }
}

extension HomeCoordinator: SetupProfileCoordinatorDependencies {
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController {
        return dependencies.makeSetupProfileViewController(actions: actions)
    }
    
    func dismiss(_ coordinator: SetupProfileCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension HomeCoordinator: RunCoordinatorDependencies {
    func makeRunViewController(actions: RunViewModelActions) -> RunViewController {
        return dependencies.makeRunViewController(actions: actions)
    }
    
    func dismiss(_ coordinator: RunCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: - HomeViewModelActionDelegate

//extension HomeCoordinator: HomeViewModelActionDelegate {
//
//    func setupProfile() {
//        let setupProfileCoordinator = SetupProfileCoordinator(navigationController: navigationController)
//        setupProfileCoordinator.delegate = self
//        setupProfileCoordinator.start()
//        childCoordinators.append(setupProfileCoordinator)
//    }
//
//    func error() {
//        delegate?.error(self)
//    }
//
//    func run(locationManager: CLLocationManager) {
//        let runCoordinator = RunCoordinator(navigationController: navigationController, locationManager: locationManager)
//        runCoordinator.start()
//        childCoordinators.append(runCoordinator)
//    }
//}

// MARK: - SetupProfileCoordinatorDelegate
//
//extension HomeCoordinator: SetupProfileCoordinatorDelegate {
//
//    func createProfile(_ coordinator: SetupProfileCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//    }
//}
//
//extension HomeCoordinator: InfoCoordinatorDelegate {
//
//    func logout(_ coordinator: InfoCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
////        delegate?.didLoggedOut(self)
//    }
//}

//extension HomeCoordinator: RunCoordinatorDelegate {
//
//    func dismiss(_ coordinator: RunCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//    }
//}
