//
//  FavoriteCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit
import CoreLocation

protocol RunCoordinatorDependencies {
    func makeRunViewController(actions: RunViewModelActions) -> RunViewController
    func dismiss(_ coordinator: RunCoordinator, _ mapInfo: MapInfo?)
}

final class RunCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: RunCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: RunCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = RunViewModelActions(toBack: toBack,
                                          showShareViewController: showShareViewController)
        let vc = dependencies.makeRunViewController(actions: actions)
        
        navigationController.pushViewController(vc, animated: true)
//        navigationController.navigationBar.isHidden = false
    }
    
    private func toBack() {
        navigationController.popViewController(animated: true)
        dependencies.dismiss(self, nil)
    }
    
    private func showShareViewController(mapInfo: MapInfo) {
        navigationController.popViewController(animated: true)
        dependencies.dismiss(self, mapInfo)
    }
    
}

//extension RunCoordinator: RunViewModelActionDelegate {
//    
//    func dismiss(with saved: Bool, snapshot: UIImage?, address: String) {
//        
//        guard saved == true else {
//            navigationController.popViewController(animated: true)
////            delegate?.dismiss(self)
//            return
//        }
//        
//        navigationController.popViewController(animated: true)
//        
//        let coordiantor = ShareInfoCoordinator(navigationController: navigationController, snapshot: snapshot!, address: address)
//        coordiantor.delegate = self
//        coordiantor.start()
//        childCoordinators.append(coordiantor)
//    }
//}

//extension RunCoordinator: ShareInfoCoordinatorDelegate {
//
//    func dismiss(_ coordinator: ShareInfoCoordinator) {
//
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
////        delegate?.dismiss(self)
//    }
//}
