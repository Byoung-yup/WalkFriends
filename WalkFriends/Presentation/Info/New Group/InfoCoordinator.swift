////
////  InfoCoordinator.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/03/08.
////
//
//import Foundation
//import UIKit
//
//protocol InfoCoordinatorDependencies {
//    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController
//    func dismiss(_ coordinator: InfoCoordinator, status signOut: Bool)
//}
//
//final class InfoCoordinator: NSObject, Coordinator {
//    
//    var childCoordinators: [NSObject] = []
//    
//    private let navigationController: UINavigationController
//    private let dependencies: InfoCoordinatorDependencies
//    
//    init(navigationController: UINavigationController, dependecies: InfoCoordinatorDependencies) {
//        self.navigationController = navigationController
//        self.dependencies = dependecies
//    }
//    
//    func start() {
//        let actions = InfoViewModelActions(changeProfile: changeProfile,
//                                           showMyFavoriteMapListView: showMyFavoriteMapListView,
//                                           signOut: signOut,
//                                           toBack: toBack)
//        let vc = dependencies.makeInfoViewController(actions: actions)
//        
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    private func toBack() {
//        dependencies.dismiss(self, status: false)
//    }
//    
//    private func changeProfile() {
//        
//    }
//    
//    private func showMyFavoriteMapListView() {
//        
//    }
//    
//    private func signOut() {
////        navigationController.popViewController(animated: false)
//        dependencies.dismiss(self, status: true)
//    }
//    
//}
