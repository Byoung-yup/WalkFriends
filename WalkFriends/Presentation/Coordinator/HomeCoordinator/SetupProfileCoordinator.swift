//
//  SetupProfileCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import UIKit

protocol SetupProfileCoordinatorDelegate {
    func createProfile(_ coordinator: SetupProfileCoordinator)
}

final class SetupProfileCoordinator: NSObject {
    
    let navigationController: UINavigationController
//    var setupProfileVC: SetupProfileViewController
    
    var delegate: SetupProfileCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.tabBarController?.tabBar.isHidden = true
        let setupProfileVC = SetupProfileViewController(viewModel: makeSetupProfileViewModel())
        navigationController.pushViewController(setupProfileVC, animated: true)
    }
}

extension SetupProfileCoordinator {
    
    // MARK: - SetupProfileViewController
    
    func makeSetupProfileViewModel() -> SetupProfileViewModel{
        let setupProfileViewModel = SetupProfileViewModel(dataUseCase: makeDataUseCase())
        setupProfileViewModel.actionDelegate = self
        return setupProfileViewModel
    }
    
    // MARK: - Create User Use Case
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
}

// MARK: - SetupProfileViewModelActionDelegate

extension SetupProfileCoordinator: SetupProfileViewModelActionDelegate {
    
    func createProfile() {
        navigationController.popViewController(animated: true) 
        delegate?.createProfile(self)
    }
    
}
