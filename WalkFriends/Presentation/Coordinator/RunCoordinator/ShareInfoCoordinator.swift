//
//  ShareInfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit

final class ShareInfoCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [NSObject] = []
    
    private let navigationController: UINavigationController
    
    let snapshot: UIImage
    
    init(navigationController: UINavigationController, snapshot: UIImage) {
        self.navigationController = navigationController
        self.snapshot = snapshot
    }
    
    func start() {
        let vc = ShareInfoViewController(viewModel: makeShareInfoViewModel(), snapshot: snapshot)
        navigationController.pushViewController(vc, animated: true)
    }

    // MARK: - ShareInfoViewController
    
    private func makeShareInfoViewModel() -> ShareInfoViewModel {
        let viewModel = ShareInfoViewModel()
        return viewModel
    }
}
