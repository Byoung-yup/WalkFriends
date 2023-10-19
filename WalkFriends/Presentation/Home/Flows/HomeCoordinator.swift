//
//  HomeCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit
import CoreLocation

protocol HomeCoordinatorDependencies {
    // MARK: coordinator
    func makeSetupProfileCoordinator(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) -> SetupProfileCoordinator
    func makeInfoCoordinator(navigationController: UINavigationController, dependencies: InfoCoordinatorDependencies) -> InfoCoordinator
    func makeRunCoordinator(navigationController: UINavigationController, dependencies: RunCoordinatorDependencies) -> RunCoordinator
    func makeShareCoordinator(navigationController: UINavigationController, dependencies: ShareInfoCoordinatorDepedencies, mapInfo: MapInfo) -> ShareInfoCoordinator
    func makeMapListDetailCoordinator(navigationController: UINavigationController, dependencies: MapListDetailCoordinatorDependencies, item: FinalMapList) -> MapListDetailCoordinator
    
    // MARK: viewController
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController
    func makeRunViewController(actions: RunViewModelActions) -> RunViewController
    func makeShareViewController(actions: ShareInfoViewModelActions, mapInfo: MapInfo) -> ShareInfoViewController
    func makeMapListDetailViewController(actions: MapListDetailViewModelActions, item: FinalMapList) -> MapListDetailViewController
    
    // MARK: dismiss
    func dismissHomeViewController(_ coordinator: HomeCoordinator)
}


final class HomeCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: HomeCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: HomeCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showInfoViewController: showInfoViewController,
                                           showSetupProfileViewController: showSetupProfileViewController,
                                           fetchError: fetchError,
                                           showRunViewController: showRunViewController,
                                           showMapListDetailViewController: showMapListDetailViewController)
        let vc = dependencies.makeHomeViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
//        navigationController.navigationBar.isHidden = false
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
    
    private func showShareViewController(mapInfo: MapInfo) {
        let shareCoordinator = dependencies.makeShareCoordinator(navigationController: navigationController, dependencies: self, mapInfo: mapInfo)
        shareCoordinator.start()
        
        childCoordinators.append(shareCoordinator)
    }
    
    private func showMapListDetailViewController(item: FinalMapList) {
        let mapListDetailCoordinator = dependencies.makeMapListDetailCoordinator(navigationController: navigationController, dependencies: self, item: item)
        mapListDetailCoordinator.start()
        
        childCoordinators.append(mapListDetailCoordinator)
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
    
    func dismiss(_ coordinator: RunCoordinator, _ mapInfo: MapInfo?) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        navigationController.navigationBar.isHidden = false
        if let mapInfo = mapInfo {
            showShareViewController(mapInfo: mapInfo)
        }
    }
}

extension HomeCoordinator: ShareInfoCoordinatorDepedencies {
    func makeShareViewController(actions: ShareInfoViewModelActions, mapInfo: MapInfo) -> ShareInfoViewController {
        return dependencies.makeShareViewController(actions: actions, mapInfo: mapInfo)
    }
    
    func dismiss(_ coordinator: ShareInfoCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        navigationController.navigationBar.isHidden = false
    }
}

extension HomeCoordinator: MapListDetailCoordinatorDependencies {
    func makeMapListDetailViewController(actions: MapListDetailViewModelActions, item: FinalMapList) -> MapListDetailViewController {
        return dependencies.makeMapListDetailViewController(actions: actions, item: item)
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
