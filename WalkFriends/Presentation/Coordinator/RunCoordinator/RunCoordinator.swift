//
//  FavoriteCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

final class RunCoordinator: NSObject {
    
    var childCoordinators: [NSObject] = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = RunViewController(viewModel: makeRunViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - HomeViewController
    
    func makeRunViewModel() -> RunViewModel {
        let runViewModel = RunViewModel()
        runViewModel.actionDelegate = self
        return runViewModel
    }
    
}

extension RunCoordinator: RunViewModelActionDelegate {
    
    func dismiss(with saved: Bool, snapshot: UIImage?) {
        
        guard saved == true else {
            navigationController.popViewController(animated: true)
            return
        }
        
        navigationController.popViewController(animated: true)
        
        let coordiantor = ShareInfoCoordinator(navigationController: navigationController, snapshot: snapshot!)
        coordiantor.start()
        childCoordinators.append(coordiantor)
    }
}

