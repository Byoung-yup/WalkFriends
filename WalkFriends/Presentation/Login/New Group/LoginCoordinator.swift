//
//  LoginCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol LoginCoordinatorDependencies {
    // MARK: Dismiss
    func dismiss(_ coordinator: LoginCoordinator, _ createUser_Trigger: Bool?)

    // MARK: Coordinator
//    func makeRegisterCoordinator(navigationController: UINavigationController, dependencies: RegisterCoordinatorDependencies) -> RegisterCoordinator
//    func makeResetCoordinator(navigationController: UINavigationController, dependencies: ResetCoordinatorDependencies) -> ResetCoordinator
    
    // MARK: ViewController
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
//    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController
//    func makeResetViewController(actions: ResetViewModelActions) -> ResetViewController
    
}

class LoginCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: LoginCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(dismiss: dismiss)
            
        let vc = dependencies.makeLoginViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    
//    private func showRegisterViewController() {
//        let registerCoordinator = dependencies.makeRegisterCoordinator(navigationController: navigationController, dependencies: self)
//        registerCoordinator.start()
//
//        childCoordinators.append(registerCoordinator)
//    }
    
    private func dismiss(_ isExisted: Bool?) {
        
        guard let isExisted = isExisted else {
            dependencies.dismiss(self, nil)
            navigationController.popViewController(animated: true)
            return
        }
        
        if isExisted {
            dependencies.dismiss(self, isExisted)
        } else {
            dependencies.dismiss(self, isExisted)
        }
//        navigationController.popViewController(animated: false)
    }
    
//    private func showResetViewController() {
//        let resetCoordiantor = dependencies.makeResetCoordinator(navigationController: navigationController, dependencies: self)
//        resetCoordiantor.start()
//
//        childCoordinators.append(resetCoordiantor)
//    }
}

//// MARK: - RegisterCoordinatorDependencies
//
//extension LoginCoordinator: RegisterCoordinatorDependencies {
//    func toBack(_ coordinator: RegisterCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//    }
//
//    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
//        return dependencies.makeRegisterViewController(actions: actions)
//    }
//}
//
//// MARK: - ResetCoordinatorDependencies
//
//extension LoginCoordinator: ResetCoordinatorDependencies {
//    func toBack(_ coordinator: ResetCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//    }
//
//    func makeResetViewController(actions: ResetViewModelActions) -> ResetViewController {
//        return dependencies.makeResetViewController(actions: actions)
//    }
//}
