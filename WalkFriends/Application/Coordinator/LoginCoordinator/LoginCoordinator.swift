//
//  LoginCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

//protocol LoginCoordinatorDelegate {
//    func didLoggedIn(_ coordinator: LoginCoordinator)
//}

protocol LoginCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func dismissLoginViewController(coordinator: LoginCoordinator)
}

class LoginCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
//    var delegate: LoginCoordinatorDelegate?
    
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
//        let loginViewController = LoginViewController(loginViewModel: makeLoginViewModel())
//        navigationController.setViewControllers([loginViewController], animated: false)
//        navigationController.navigationBar.isHidden = true
    }
    
    private func showRegisterViewController() {
        
    }
    
    private func signIn() {
        dependencies.dismissLoginViewController(coordinator: self)
    }
    
//    // MARK: - LoginViewController
//
//    private func makeLoginViewModel() -> LoginViewModel {
//        let loginViewModel = LoginViewModel()
//        loginViewModel.actionDelegate = self
//        return loginViewModel
//    }
//
}
//
//extension LoginCoordinator: LoginViewModelActionDelegate {
//
//    func showRegisterVC() {
//
//        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
//        registerCoordinator.delegate = self
//        registerCoordinator.start()
//        childCoordinators.append(registerCoordinator)
//
//    }
//
//    func signIn() {
//        delegate?.didLoggedIn(self)
//    }
//
//}
//
//extension LoginCoordinator: RegisterCoordinatorDelegate {
//
//    func toBack(_ coordinator: RegisterCoordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
//    }
//}
