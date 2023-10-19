//
//  ResetCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/02.
//
import Foundation
import UIKit

protocol ResetCoordinatorDependencies {
    func toBack(_ coordinator: ResetCoordinator)
    func makeResetViewController(actions: ResetViewModelActions) -> ResetViewController
}

final class ResetCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    private let dependencies: ResetCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: ResetCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ResetViewModelActions(toBack: toBack)
        let vc = dependencies.makeResetViewController(actions: actions)
        
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    private func toBack() {
        dependencies.toBack(self)
        navigationController.dismiss(animated: true)
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
}
