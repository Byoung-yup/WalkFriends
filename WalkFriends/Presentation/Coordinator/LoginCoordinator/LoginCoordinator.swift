//
//  LoginCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    var delegate: LoginCoordinatorDelegate?
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let loginViewController = LoginViewController(loginViewModel: makeLoginViewModel())
        navigationController.viewControllers = [loginViewController]
        
    }
    
    // MARK: - LoginViewController
    
    func makeLoginViewModel() -> LoginViewModel {
        let homeViewModel = LoginViewModel()
        homeViewModel.actionDelegate = self
        return homeViewModel
    }
    
}

extension LoginCoordinator: LoginViewModelActionDelegate {
    
    func showRegisterVC() {
        
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.delegate = self
        registerCoordinator.start()
        childCoordinators.append(registerCoordinator)
        
    }
    
    func signIn() {
        delegate?.didLoggedIn(self)
    }

}

extension LoginCoordinator: RegisterCoordinatorDelegate {
    
    func toBack(_ coordinator: RegisterCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
