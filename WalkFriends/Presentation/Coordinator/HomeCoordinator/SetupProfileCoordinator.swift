//
//  SetupProfileCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/13.
//

import Foundation
import UIKit

final class SetupProfileCoordinator: NSObject {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.tabBarController?.tabBar.isHidden = true
        let setupProfileVC = SetupProfileViewController(viewModel: makeSetupProfileViewModel())
        navigationController.pushViewController(setupProfileVC, animated: true)
    }
}

extension SetupProfileCoordinator {
    
    // MARK: SetupProfileViewController
    func makeSetupProfileViewModel() -> SetupProfileViewModel{
        let setupProfileViewModel = SetupProfileViewModel()
        return setupProfileViewModel
    }
    
    // MARK: Create User Use Case
    
}
