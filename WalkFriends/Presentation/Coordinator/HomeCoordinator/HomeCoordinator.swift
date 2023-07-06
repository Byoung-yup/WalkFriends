//
//  HomeCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate {
    func didLoggedOut(_ coordinator: HomeCoordinator)
    func error(_ coordinator: HomeCoordinator)
}


final class HomeCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    var delegate: HomeCoordinatorDelegate?
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController(homeViewModel: makeHomeViewModel())
        navigationController.setViewControllers([vc], animated: false)
        navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - HomeViewController
    
    func makeHomeViewModel() -> HomeViewModel {
        let homeViewModel = HomeViewModel(dataUseCase: makeDataUseCase())
        homeViewModel.actionDelegate = self
        return homeViewModel
    }
    
    // MARK: - Use Cases
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
}

// MARK: - HomeViewModelActionDelegate

extension HomeCoordinator: HomeViewModelActionDelegate {
    
    func setupProfile() {
        let setupProfileCoordinator = SetupProfileCoordinator(navigationController: navigationController)
        setupProfileCoordinator.delegate = self
        setupProfileCoordinator.start()
        childCoordinators.append(setupProfileCoordinator)
    }
    
    func error() {
        delegate?.error(self)
    }
    
}

// MARK: - SetupProfileCoordinatorDelegate

extension HomeCoordinator: SetupProfileCoordinatorDelegate {
    
    func createProfile(_ coordinator: SetupProfileCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension HomeCoordinator: InfoCoordinatorDelegate {
    
    func logout(_ coordinator: InfoCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        delegate?.didLoggedOut(self)
    }
}

extension HomeCoordinator: RunCoordinatorDelegate {
    
    func dismiss(_ coordinator: RunCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
