//
//  LoginCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol LoginCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func dismissLoginViewController(_ coordinator: LoginCoordinator)
    func makeRegisterCoordinator(navigationController: UINavigationController, dependencies: RegisterCoordinatorDependencies) -> RegisterCoordinator
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController
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
        let actions = LoginViewModelActions(showRegisterViewController: showRegisterViewController, signIn: signIn)
        let vc = dependencies.makeLoginViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    
    private func showRegisterViewController() {
        let registerCoordinator = dependencies.makeRegisterCoordinator(navigationController: navigationController, dependencies: self)
        registerCoordinator.start()
        
        childCoordinators.append(registerCoordinator)
    }
    
    private func signIn() {
        dependencies.dismissLoginViewController(self)
    }
}

extension LoginCoordinator: RegisterCoordinatorDependencies {
    func toBack(_ coordinator: RegisterCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
        return dependencies.makeRegisterViewController(actions: actions)
    }
}
