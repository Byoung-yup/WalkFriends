//
//  HomeCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit
import CoreLocation

//protocol HomeCoordinatorDelegate {
//    func didLoggedOut(_ coordinator: HomeCoordinator)
//    func error(_ coordinator: HomeCoordinator)
//}

protocol HomeCoordinatorDepedencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController
    func dismissHomeViewController(coordinator: HomeCoordinator)
}


final class HomeCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
//    var delegate: HomeCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    private let dependencies: HomeCoordinatorDepedencies
    
    init(navigationController: UINavigationController, dependencies: HomeCoordinatorDepedencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showInfoViewController: showInfoViewController,
                                           showSetupProfileViewController: showSetupProfileViewController)
        let vc = dependencies.makeHomeViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        
//        let vc = HomeViewController(homeViewModel: makeHomeViewModel())
//        navigationController.setViewControllers([vc], animated: false)
//        navigationController.navigationBar.isHidden = true
    }
    
    private func showInfoViewController() {
        let infoCoordinator = InfoCoordinator(navigationController: navigationController, dependecies: dependencies, homeCoordinator: self)
        infoCoordinator.start()
        
//        childCoordinators.append(infoCoordinator)
    }
    
    private func showSetupProfileViewController() {
        
    }
    
    // MARK: - HomeViewController
    
//    func makeHomeViewModel() -> HomeViewModel {
//        let homeViewModel = HomeViewModel(dataUseCase: makeDataUseCase())
//        homeViewModel.actionDelegate = self
//        return homeViewModel
//    }
    
    // MARK: - Use Cases
//
//    func makeDataUseCase() -> DataUseCase {
//        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
//    }
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

extension HomeCoordinator: SetupProfileCoordinatorDelegate {
    
    func createProfile(_ coordinator: SetupProfileCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
//
//extension HomeCoordinator: InfoCoordinatorDelegate {
//
//    func logout(_ coordinator: InfoCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
////        delegate?.didLoggedOut(self)
//    }
//}

extension HomeCoordinator: RunCoordinatorDelegate {
    
    func dismiss(_ coordinator: RunCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
