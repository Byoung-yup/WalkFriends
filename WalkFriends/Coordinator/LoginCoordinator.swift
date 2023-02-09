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

class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let loginViewController = LoginViewController(loginViewModel: LoginViewModel())
        loginViewController.delegate = self
        navigationController.viewControllers = [loginViewController]
        
    }
    
}

extension LoginCoordinator: LoginViewControllerDelegate {
    
    func showRegisterVC() {
        
        let registerViewController = RegisterViewController(registerViewModel: RegiterViewModel())
        registerViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(registerViewController, animated: true)
        
    }
    
    func signIn() {
        delegate?.didLoggedIn(self)
    }

}
