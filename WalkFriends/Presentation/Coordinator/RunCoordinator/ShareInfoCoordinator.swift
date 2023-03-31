//
//  ShareInfoCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit

final class ShareInfoCoordinator: NSObject {
    
    private let navigationController: UINavigationController
    
    let snapshot: UIImage
    
    init(navigationController: UINavigationController, snapshot: UIImage) {
        self.navigationController = navigationController
        self.snapshot = snapshot
    }
    
    func start() {
        let vc = ShareInfoViewController(snapshot: snapshot)
        navigationController.pushViewController(vc, animated: true)
    }
}
