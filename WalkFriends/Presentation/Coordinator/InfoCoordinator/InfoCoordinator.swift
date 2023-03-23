//
//  InfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

protocol InfoCoordinatorDelegate {
    func logout()
}

final class InfoCoordinator: NSObject {
    
    let navigationController: UINavigationController
    var delegate: InfoCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = InfoViewController(viewModel: makeInfoViewModel())
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
        FirebaseService.shard.logout { [weak self] _ in
            self?.delegate?.logout()
        }
    }
}
