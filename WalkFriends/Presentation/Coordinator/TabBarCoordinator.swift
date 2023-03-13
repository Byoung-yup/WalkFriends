//
//  MainCoordinator.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

protocol TabBarCoordinatorDelegate {
    func didLoggedOut(_ coordinator: TabBarCoordinator)
}

class TabBarCoordinator: NSObject {
    
    var tabBarController: UITabBarController
    
    var childCoordinators: [NSObject] = []
    var delegate: TabBarCoordinatorDelegate?
    
    var favoriteCoordinator: FavoriteCoordinator
    var messageCoordinator: MessageCoordinator
    var homeCoordinator: HomeCoordinator
    var alarmCoordinator: AlarmCoordinator
    var infoCoordinator: InfoCoordinator
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        favoriteCoordinator = FavoriteCoordinator(navigationController: UINavigationController())
        messageCoordinator = MessageCoordinator(navigationController: UINavigationController())
        homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        alarmCoordinator = AlarmCoordinator(navigationController: UINavigationController())
        infoCoordinator = InfoCoordinator(navigationController: UINavigationController())
        
    }
    
    func start() {
        
        var controllers: [UIViewController] = []
        
        favoriteCoordinator.start()
        messageCoordinator.start()
        homeCoordinator.start()
        alarmCoordinator.start()
        infoCoordinator.start()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light)
        
        // Create Tab one
        let favoriteVC = favoriteCoordinator.navigationController
        let tabOneBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "list.bullet.clipboard", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill", withConfiguration: imageConfig))
        favoriteVC.tabBarItem = tabOneBarItem
        childCoordinators.append(favoriteCoordinator)
        
        // Create Tab Two
        let messageVC = messageCoordinator.navigationController
        let tabTwoBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "ellipsis.message", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "ellipsis.message.fill", withConfiguration: imageConfig))
        messageVC.tabBarItem = tabTwoBarItem
        childCoordinators.append(messageCoordinator)
        
        // Create Tab Three
        let homeVC = homeCoordinator.navigationController
        let tabThreeBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "house.fill", withConfiguration: imageConfig))
        homeVC.tabBarItem = tabThreeBarItem
        childCoordinators.append(homeCoordinator)
        
        // Create Tab Four
        let alarmVC = alarmCoordinator.navigationController
        let tabFourBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "bell.fill", withConfiguration: imageConfig))
        alarmVC.tabBarItem = tabFourBarItem
        childCoordinators.append(alarmCoordinator)
        
        // Create Tab Five
        let infoVC = infoCoordinator.navigationController
        let tabFiveBarItem = UITabBarItem(title: "내 정보", image: UIImage(systemName: "person", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "person.fill", withConfiguration: imageConfig))
        infoVC.tabBarItem = tabFiveBarItem
        infoCoordinator.delegate = self
        childCoordinators.append(infoCoordinator)
        
        
        controllers.append(favoriteVC)
        controllers.append(messageVC)
        controllers.append(homeVC)
        controllers.append(alarmVC)
        controllers.append(infoVC)
        
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.delegate = self
        
        configureTabBar()
    }
    
    private func configureTabBar() {
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [.font: UIFont(name: "LettersforLearners", size: 10)!]
            tabBarItemAppearance.selected.titleTextAttributes = [.font: UIFont(name: "LettersforLearners", size: 10)!]
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
            
        } else {
            tabBarController.tabBarItem.setTitleTextAttributes([.font: UIFont(name: "LettersforLearners", size: 10)!], for: .normal)
            tabBarController.tabBar.backgroundColor = .white
        }
        
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.tintColor = .orange
        
        tabBarController.selectedIndex = 2
        
    }
    
}

extension TabBarCoordinator: InfoCoordinatorDelegate {

    func logout() {
        
        childCoordinators = childCoordinators.filter { $0 == self }
        delegate?.didLoggedOut(self)
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {}

