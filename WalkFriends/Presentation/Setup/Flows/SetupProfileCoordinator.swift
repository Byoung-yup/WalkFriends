//
//  SetupProfileCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import UIKit

protocol SetupProfileCoordinatorDependencies {
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController
    func dismiss(_ coordinator: SetupProfileCoordinator)
}

final class SetupProfileCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: SetupProfileCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = SetupViewModelActions(createProfile: createProfile)
        let vc = dependencies.makeSetupProfileViewController(actions: actions)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.pushViewController(vc, animated: false)
    }
    
    private func createProfile() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromBottom
        
        dependencies.dismiss(self)
        
        navigationController.view.layer.add(transition, forKey: kCATransition)
//        navigationController.popViewController(animated: false)
    }
}

//extension SetupProfileCoordinator {
//
//    // MARK: - SetupProfileViewController
//
//    func makeSetupProfileViewModel() -> SetupProfileViewModel{
//        let setupProfileViewModel = SetupProfileViewModel(dataUseCase: makeDataUseCase())
//        setupProfileViewModel.actionDelegate = self
//        return setupProfileViewModel
//    }
//
//    // MARK: - Create User Use Case
//
//    func makeDataUseCase() -> DataUseCase {
//        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
//    }
//}
//
//// MARK: - SetupProfileViewModelActionDelegate
//
//extension SetupProfileCoordinator: SetupProfileViewModelActionDelegate {
//
//    func createProfile() {
//        navigationController.popViewController(animated: true)
//        delegate?.createProfile(self)
//    }
//
//}
