//
//  RegisterCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/08.
//

import Foundation
import UIKit

protocol RegisterCoordinatorDelegate {
    func toBack(_ coordinator: RegisterCoordinator)
}

class RegisterCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    var delegate: RegisterCoordinatorDelegate?
    
//    private var registerViewController: RegisterViewController!
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let registerViewController = RegisterViewController(registerViewModel: makeRegisterViewModel())
//        self.registerViewController = registerViewController
        navigationController.pushViewController(registerViewController, animated: true)
        navigationController.navigationBar.isHidden = true
        
    }
    
    // MARK: - RegisterViewController
    
    func makeRegisterViewModel() -> RegiterViewModel {
        
        let registerViewModel = RegiterViewModel()
        registerViewModel.actionDelegate = self
        return registerViewModel
    }
}

extension RegisterCoordinator: RegisterViewModelActionDelegate {
    
    func toBack() {
        navigationController.popViewController(animated: true)
        delegate?.toBack(self)
    }
    
//    func showEmailConfirmVC() {
//        let coordinator = EmailCoordinator(viewcontroller: registerViewController)
//        coordinator.start()
//        childCoordinators.append(coordinator)
//    }
}
