//
//  MainViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light)
        
        // Create Tab one
        let tabOne = FavoriteListViewController()
        let tabOneBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "list.bullet.clipboard", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill", withConfiguration: imageConfig))
        tabOne.tabBarItem = tabOneBarItem
        
        // Create Tab Two
        let tabTwo = MessagesViewController()
        let tabTwoBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "ellipsis.message", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "ellipsis.message.fill", withConfiguration: imageConfig))
        tabTwo.tabBarItem = tabTwoBarItem
        
        // Create Tab Three
        let tabThree = HomeViewController()
        let tabThreeBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "house.fill", withConfiguration: imageConfig))
        tabThree.tabBarItem = tabThreeBarItem
        
        // Create Tab Four
        let tabFour = AlarmViewController()
        let tabFourBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "bell.fill", withConfiguration: imageConfig))
        tabFour.tabBarItem = tabFourBarItem
        
        // Create Tab Five
        let tabFive = InfoViewController()
        let tabFiveNavigationController = UINavigationController(rootViewController: tabFive)
        let tabFiveBarItem = UITabBarItem(title: "내 정보", image: UIImage(systemName: "person", withConfiguration: imageConfig), selectedImage: UIImage(systemName: "person.fill", withConfiguration: imageConfig))
        tabFiveNavigationController.tabBarItem = tabFiveBarItem
        
        viewControllers = [tabOne, tabTwo, tabThree, tabFour, tabFiveNavigationController]
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [.font: UIFont(name: "LettersforLearners", size: 10)!]
            tabBarItemAppearance.selected.titleTextAttributes = [.font: UIFont(name: "LettersforLearners", size: 10)!]
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
        } else {
            tabBarItem.setTitleTextAttributes([.font: UIFont(name: "LettersforLearners", size: 10)!], for: .normal)
            tabBar.backgroundColor = .white
        }
    
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .orange
        
        selectedIndex = 2
    }
    
}

