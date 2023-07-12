//
//  MapListDetailCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import UIKit

final class MapListDetailCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    
    private let item: MapList
    
    init(navigationController: UINavigationController, item: MapList) {
        self.navigationController = navigationController
        self.item = item
    }
    
    func start() {
        let vc = MapListDetailViewController(mapListDetailViewModel: makeMapListDetailViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - MapListViewController
    
    private func makeMapListDetailViewModel() -> MapListDetailViewModel {
        let viewModel = MapListDetailViewModel(dataUseCase: makeDataUseCase(), item: item)
//        viewModel.actionDelegate = self
        return viewModel
    }
    
    // MARK: - Use Cases
    
    func makeDataUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
}
