//
//  InfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

protocol InfoCoordinatorDelegate {
    func logout(_ coordinator: InfoCoordinator)
}

final class InfoCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    var delegate: InfoCoordinatorDelegate?
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = InfoViewController(infoViewModel: makeInfoViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
}

extension InfoCoordinator {
    
    // MARK: - InfoViewController
    
    private func makeInfoViewModel() -> InfoViewModel {
        let infoViewModel = InfoViewModel()
        infoViewModel.actionDelegate = self
        
        return infoViewModel
    }

}

    // MARK: - InfoViewControllerActionDelegate

extension InfoCoordinator: InfoViewControllerActionDelegate {
    
    func logOut() {
        delegate?.logout(self)
    }
}
