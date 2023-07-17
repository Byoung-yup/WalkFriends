//
//  FavoriteCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation
import UIKit
import CoreLocation

protocol RunCoordinatorDelegate {
    func dismiss(_ coordinator: RunCoordinator)
}

final class RunCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    let navigationController: UINavigationController
    
    let locationManager: CLLocationManager
    var delegate: RunCoordinatorDelegate?
    
    init(navigationController: UINavigationController, locationManager: CLLocationManager) {
        self.navigationController = navigationController
        self.locationManager = locationManager
    }
    
    func start() {
        let vc = RunViewController(viewModel: makeRunViewModel(), locationManager: locationManager)
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
    
    func dismiss(with saved: Bool, snapshot: UIImage?, address: String) {
        
        guard saved == true else {
            navigationController.popViewController(animated: true)
            delegate?.dismiss(self)
            return
        }
        
        navigationController.popViewController(animated: true)
        
        let coordiantor = ShareInfoCoordinator(navigationController: navigationController, snapshot: snapshot!, address: address)
        coordiantor.delegate = self
        coordiantor.start()
        childCoordinators.append(coordiantor)
    }
}

extension RunCoordinator: ShareInfoCoordinatorDelegate {
    
    func dismiss(_ coordinator: ShareInfoCoordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        delegate?.dismiss(self)
    }
}