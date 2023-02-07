//
//  LoginCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

final class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let loginViewController = LoginViewController()
        loginViewController.delegate = self
        navigationController.viewControllers = [loginViewController]
        
    }
    
}

extension LoginCoordinator: showRegisterVCDelegate {
    
    func showRegisterVC() {
        
        let registerViewController = RegisterViewController(registerViewModel: RegiterViewModel())
        registerViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(registerViewController, animated: true)
        
    }

}
