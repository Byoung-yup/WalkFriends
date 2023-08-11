//
//  ShareInfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit

protocol ShareInfoCoordinatorDepedencies {
    func dismiss(_ coordinator: ShareInfoCoordinator)
    func makeShareViewController(actions: ShareInfoViewModelActions, mapInfo: MapInfo) -> ShareInfoViewController
}

final class ShareInfoCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: ShareInfoCoordinatorDepedencies
    
    private let mapInfo: MapInfo
    
    init(navigationController: UINavigationController, dependenceis: ShareInfoCoordinatorDepedencies, mapInfo: MapInfo) {
        self.navigationController = navigationController
        self.dependencies = dependenceis
        self.mapInfo = mapInfo
    }
    
    func start() {
        let actions = ShareInfoViewModelActions(toBack: toBack)
        let vc = dependencies.makeShareViewController(actions: actions, mapInfo: mapInfo)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func toBack() {
        navigationController.popViewController(animated: true)
        dependencies.dismiss(self)
    }
}

