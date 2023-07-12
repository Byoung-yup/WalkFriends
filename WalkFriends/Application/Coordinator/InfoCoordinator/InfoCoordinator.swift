//
//  InfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit

//protocol InfoCoordinatorDelegate {
//    func logout(_ coordinator: InfoCoordinator)
//}

final class InfoCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
//    var delegate: InfoCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    private let dependencies: HomeCoordinatorDepedencies
    private let homeCoordinator: HomeCoordinator
    
    init(navigationController: UINavigationController, dependecies: HomeCoordinatorDepedencies, homeCoordinator: HomeCoordinator) {
        self.navigationController = navigationController
        self.dependencies = dependecies
        self.homeCoordinator = homeCoordinator
    }
    
    func start() {
        let actions = InfoViewModelActions(changeProfile: changeProfile,
                                           showMyFavoriteMapListView: showMyFavoriteMapListView,
                                           signOut: signOut)
        let vc = dependencies.makeInfoViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
//        let vc = InfoViewController(infoViewModel: makeInfoViewModel())
//        navigationController.pushViewController(vc, animated: true)
    }
    
    private func changeProfile() {
        
    }
    
    private func showMyFavoriteMapListView() {
        
    }
    
    private func signOut() {
        navigationController.popViewController(animated: false)
        dependencies.dismissHomeViewController(coordinator: homeCoordinator)
    }
    
}

//extension InfoCoordinator {
//
//    // MARK: - InfoViewController
//
//    private func makeInfoViewModel() -> InfoViewModel {
//        let infoViewModel = InfoViewModel()
//        infoViewModel.actionDelegate = self
//
//        return infoViewModel
//    }
//
//}
//
//    // MARK: - InfoViewControllerActionDelegate
//
//extension InfoCoordinator: InfoViewControllerActionDelegate {
//
//    func logOut() {
//        delegate?.logout(self)
//    }
//}
