//
//  ShareInfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit

protocol ShareInfoCoordinatorDelegate {
    func dismiss(_ coordinator: ShareInfoCoordinator)
}

final class ShareInfoCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    var delegate: ShareInfoCoordinatorDelegate?
    
    let snapshot: UIImage
    let address: String
    
    init(navigationController: UINavigationController, snapshot: UIImage, address: String) {
        self.navigationController = navigationController
        self.snapshot = snapshot
        self.address = address
    }
    
    func start() {
        let vc = ShareInfoViewController(viewModel: makeShareInfoViewModel(), snapshot: snapshot, addressInfo: address)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }

    // MARK: - ShareInfoViewController
    
    private func makeShareInfoViewModel() -> ShareInfoViewModel {
        let viewModel = ShareInfoViewModel(dataUseCase: makeDataUseCase())
        viewModel.actionDelegate = self
        return viewModel
    }
    
    // MARK: - Use Cases
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
}

extension ShareInfoCoordinator: ShareInfoViewModelActionDelegate {
    
    func dismiss() {
        navigationController.popViewController(animated: true)
        delegate?.dismiss(self)
    }
}

