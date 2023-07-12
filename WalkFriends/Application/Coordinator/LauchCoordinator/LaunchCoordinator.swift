////
////  LaunchCoordinator.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/07/03.
////
//
//import Foundation
//import UIKit
//
//class LaunchCoordinator: NSObject, Coordinator {
//    
//    var childCoordinators: [NSObject] = []
//    
//    private let navigationController: UINavigationController!
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        
//        let launchViewController = LaunchViewController()
//        navigationController.setViewControllers([launchViewController], animated: false)
//        navigationController.navigationBar.isHidden = true
//    }
//}
//
