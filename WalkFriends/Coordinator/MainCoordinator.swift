//
//  MainCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var delegate: MainCoordinatorDelegate?
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let mainViewController = MainViewController()
        mainViewController.mainDelegate = self
        
        navigationController.viewControllers = [mainViewController]
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
}

extension MainCoordinator: MainViewControllerDelegate {

    func logout() {
        delegate?.didLoggedOut(self)
    }
}
