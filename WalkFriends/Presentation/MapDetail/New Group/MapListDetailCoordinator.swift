//
//  MapListDetailCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import UIKit

protocol MapListDetailCoordinatorDependencies {
    func makeMapListDetailViewController(actions: MapListDetailViewModelActions, item: FinalMapList) -> MapListDetailViewController
}

final class MapListDetailCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: MapListDetailCoordinatorDependencies
    private let item: FinalMapList
    
    init(navigationController: UINavigationController, dependencies: MapListDetailCoordinatorDependencies, item: FinalMapList) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.item = item
    }
    
    func start() {
        let actions = MapListDetailViewModelActions()
        let vc = dependencies.makeMapListDetailViewController(actions: actions, item: item)
        
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.isHidden = true
    }

}
