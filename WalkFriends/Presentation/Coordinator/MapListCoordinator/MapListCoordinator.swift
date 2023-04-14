//
//  File.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation
import UIKit

final class MapListCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MapListViewController(mapListViewModel: makeMapListViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - MapListViewController
    
    private func makeMapListViewModel() -> MapListViewModel {
        let viewModel = MapListViewModel(dataUseCase: makeDataUseCase())
//        viewModel.actionDelegate = self
        return viewModel
    }
    
    // MARK: - Use Cases
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
}
