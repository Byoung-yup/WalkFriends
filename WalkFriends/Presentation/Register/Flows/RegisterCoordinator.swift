//
//  RegisterCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/08.
//

import Foundation
import UIKit

protocol RegisterCoordinatorDependencies {
    func toBack(_ coordinator: RegisterCoordinator)
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController
}

class RegisterCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: RegisterCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: RegisterCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = RegisterViewModelActions(toBack: toBack)
        let vc = dependencies.makeRegisterViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    
    private func toBack() {
        navigationController.popViewController(animated: true)
        dependencies.toBack(self)
    }
    
//    // MARK: - RegisterViewController
//
//    func makeRegisterViewModel() -> RegiterViewModel {
//
//        let registerViewModel = RegiterViewModel()
//        registerViewModel.actionDelegate = self
//        return registerViewModel
//    }
//}
//
//extension RegisterCoordinator: RegisterViewModelActionDelegate {
//
//    func toBack() {
//        navigationController.popViewController(animated: true)
//        delegate?.toBack(self)
//    }
//
//    func showEmailConfirmVC() {
//        let coordinator = EmailCoordinator(viewcontroller: registerViewController)
//        coordinator.start()
//        childCoordinators.append(coordinator)
//    }
}
