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
    
    func makeHomeViewModel() -> DefaultHomeViewModel {
        let homeViewModel = DefaultHomeViewModel(fetchDataUseCase: makeFetchDataUseCase())
        homeViewModel.actionDelegate = self
        return homeViewModel
    }
    
    // MARK: - Use Cases
    
    func makeFetchDataUseCase() -> FetchDataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager())
    }
}

// MARK: - HomeViewModelActionDelegate

extension HomeCoordinator: HomeViewModelActionDelegate {
    
    func setupProfile() {
        let setupProfileCoordinator = SetupProfileCoordinator(navigationController: navigationController)
        setupProfileCoordinator.start()
        childCoordinators.append(setupProfileCoordinator)
    }
    
}
