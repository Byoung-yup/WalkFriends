//
//  HomeCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit


final class HomeCoordinator: NSObject {
    
    var childCoordinators: [NSObject] = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController(homeViewModel: makeHomeViewModel())
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - HomeViewController
    
    func makeHomeViewModel() -> HomeViewModel {
        let homeViewModel = HomeViewModel(dataUseCase: makeDataUseCase())
        homeViewModel.actionDelegate = self
        return homeViewModel
    }
    
    // MARK: - Use Cases
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager())
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
    
    func present(from presenter: Presenter) {
        
        switch presenter {
        case .Run:
            let coordinator = RunCoordinator(navigationController: navigationController)
            coordinator.start()
        case .Menu:
            break
        case .None:
            break
        case .Profile:
            let coordinator = InfoCoordinator(navigationController: navigationController)
            coordinator.start()
        }
    }
    
}

extension HomeCoordinator: SetupProfileCoordinatorDelegate {
    
    func createProfile(_ coordinator: SetupProfileCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
